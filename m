Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3C0O1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:27:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46939 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3C0O07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:26:59 -0400
Message-ID: <1364394409.5053.78.camel@laptop>
Subject: Re: [PATCH v2] perf: add callgrind conversion tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roberto Vitillo <ravitillo@lbl.gov>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org
Date: Wed, 27 Mar 2013 15:26:49 +0100
In-Reply-To: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
References: <CA+BNSkWCX2TVYU26A7qHFqr6F5Pw44wy76BSfnS5MnVDKGCh9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This sort of reminds me of another little proglet I have lying about
that might need a home..


---
/*
 * Library to hook into code compiled with -finstrument-functions it will
 * record function arcs (call_fn, this_fn) as well as the sum of whatever event
 * is being measured over that function.
 *
 * Copyright (C) 2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
 *
 * This file is copyrighted under the GPLv2 License (and not any later version).
 *
 * SuperFastHash under LGPLv2.1 (http://www.azillionmonkeys.com/qed/hash.html)
 *
 * Compilation example:
 * gcc -shared -fPIC profviz.c -o profviz.so -lpthread -ldl -lelf
 *
 * Usage example:
 * LD_PRELOAD=./profviz.so your_program 
 */

#define _GNU_SOURCE

#include "util/util.h"
#include "perf.h"
#include "util/parse-events.h"

#include <sys/time.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <pthread.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <libelf.h>
#include <gelf.h>
#include <link.h>
#include <math.h>

#define barrier() asm volatile("" ::: "memory")

static u64 rdpmc(unsigned int counter)
{
	unsigned int low, high;

	asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));

	return low | ((u64)high) << 32;
}

static u64 rdtsc(void)
{
	unsigned int low, high;

	asm volatile("rdtsc" : "=a" (low), "=d" (high));

	return low | ((u64)high) << 32;
}

static u64 mmap_read_self(void *addr)
{
	struct perf_event_mmap_page *pc = addr;
	u32 seq, idx, time_mult = 0, time_shift = 0, width = 0;
	u64 count, cyc = 0, time_offset = 0, enabled, running, delta;
	s64 pmc = 0;

	do {
		seq = pc->lock;
		barrier();

		enabled = pc->time_enabled;
		running = pc->time_running;

		if (pc->cap_usr_time && enabled != running) {
			cyc = rdtsc();
			time_mult = pc->time_mult;
			time_shift = pc->time_shift;
			time_offset = pc->time_offset;
		}

		idx = pc->index;
		count = pc->offset;
		if (pc->cap_usr_rdpmc && idx) {
			width = pc->pmc_width;
			pmc = rdpmc(idx - 1);
		}

		barrier();
	} while (pc->lock != seq);

	if (idx) {
		pmc <<= 64 - width;
		pmc >>= 64 - width; /* shift right signed */
		count += pmc;
	}

	if (enabled != running) {
		u64 quot, rem;

		quot = (cyc >> time_shift);
		rem = cyc & ((1 << time_shift) - 1);
		delta = time_offset + quot * time_mult +
			((rem * time_mult) >> time_shift);

		enabled += delta;
		if (idx)
			running += delta;

		quot = count / running;
		rem = count % running;
		count = quot * enabled + (rem * enabled) / running;
	}

	return count;
}

static int (*pthread_create_orig)(pthread_t *__restrict,
		__const pthread_attr_t *__restrict,
		void *(*)(void *),
		void *__restrict) = NULL;

static struct perf_event_attr perf_attr = {
	.type = PERF_TYPE_HARDWARE,
	.config = PERF_COUNT_HW_CPU_CYCLES,
	.exclude_kernel = 1,
};

struct prof_arc {
	void *call_fn;
	void *this_fn;
	uint64_t count;
};

struct prof_fn {
	void *this_fn;
	uint64_t count;
};

#define get16bits(d) ((((uint32_t)(((const uint8_t *)(d))[1])) << 8) \
		                       +(uint32_t)(((const uint8_t *)(d))[0]) )

static uint32_t SuperFastHash (const char * data, int len, uint32_t hash) {
	uint32_t tmp;
	int rem;

	if (len <= 0 || data == NULL) return 0;

	rem = len & 3;
	len >>= 2;

	/* Main loop */
	for (;len > 0; len--) {
		hash  += get16bits (data);
		tmp    = (get16bits (data+2) << 11) ^ hash;
		hash   = (hash << 16) ^ tmp;
		data  += 2*sizeof (uint16_t);
		hash  += hash >> 11;
	}

	/* Handle end cases */
	switch (rem) {
		case 3: hash += get16bits (data);
			hash ^= hash << 16;
			hash ^= data[sizeof (uint16_t)] << 18;
			hash += hash >> 11;
			break;
		case 2: hash += get16bits (data);
			hash ^= hash << 11;
			hash += hash >> 17;
			break;
		case 1: hash += *data;
			hash ^= hash << 10;
			hash += hash >> 1;
	}

	/* Force "avalanching" of final 127 bits */
	hash ^= hash << 3;
	hash += hash >> 5;
	hash ^= hash << 4;
	hash += hash >> 17;
	hash ^= hash << 25;
	hash += hash >> 6;

	return hash;
}

void die(const char *err, ...)
{
	va_list params;

	va_start(params, err);
	vfprintf(stderr, err, params);
	va_end(params);

	exit(-1);
}


#define HASH_TABLE_SIZE		16384
#define AVG_STACK_DEPTH		8

#define ARC_HASH_SIZE	(HASH_TABLE_SIZE * AVG_STACK_DEPTH)

static struct prof_arc prof_arc_hash[ARC_HASH_SIZE];
static pthread_mutex_t prof_arc_lock;

#define FN_HASH_SIZE	(HASH_TABLE_SIZE)

static struct prof_fn  prof_fn_hash[FN_HASH_SIZE];
static pthread_mutex_t prof_fn_lock;

#define HASH_INIT		0x9e370001UL	
#define HASH_CHAIN		16

static inline void *
prof_hash_find(void *hash_base, const size_t hash_size, 
		const void *key, const size_t key_size,
		const size_t entry_size, pthread_mutex_t *lock)

{
	uint32_t hash = HASH_INIT;
	void *entry = NULL;
	int i, j;

	for (i = 0; i < HASH_CHAIN; i++) {
		hash = SuperFastHash(key, key_size, hash);
		entry = hash_base + entry_size * (hash % FN_HASH_SIZE);
		if (!memcmp(entry, key, key_size))
			return entry;

		for (j = 0; j < key_size; j++) {
			if (*((char *)entry + j))
				goto next_1;
		}

		goto found_empty;
next_1:
		continue;
	}
	die("fn_hash too full");

found_empty:
	hash = HASH_INIT;
	pthread_mutex_lock(lock);
	for (i = 0; i < HASH_CHAIN; i++) {
		hash = SuperFastHash(key, key_size, hash);
		entry = hash_base + entry_size * (hash % FN_HASH_SIZE);

		if (!memcmp(entry, key, key_size))
			goto unlock;

		for (j = 0; j < key_size; j++) {
			if (*((char *)entry + j))
				goto next_2;
		}

		memcpy(entry, key, key_size);
		goto unlock;
next_2:
		continue;
	}
	die("fn_hash too full (locked)");
unlock:
	pthread_mutex_unlock(lock);

	return entry;
}

static struct prof_fn *prof_fn_find(void *this_fn)
{
	return prof_hash_find(prof_fn_hash, FN_HASH_SIZE,
			&this_fn, sizeof(this_fn), sizeof(struct prof_fn),
			&prof_fn_lock);
}

static struct prof_arc *prof_arc_find(void *this_fn, void *call_fn)
{
	struct prof_arc arc = { .this_fn = this_fn, .call_fn = call_fn, };

	return prof_hash_find(prof_arc_hash, ARC_HASH_SIZE,
			&arc, 2*sizeof(void *), sizeof(struct prof_arc),
			&prof_arc_lock);
}

static unsigned long page_size;

struct prof_stack {
	struct prof_arc *arc;
	struct prof_fn *fn;
	uint64_t stamp;
};

static __thread struct prof_stack prof_stack[128];
static __thread int prof_stack_idx = 0;

static __thread void *perf_event;

static void thread_init(void)
{
	int fd;

	fd = sys_perf_event_open(&perf_attr, 0, -1, -1, 0);
	if (fd < 0)
		die("failed to create perf_event");

	perf_event = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
	if (perf_event == (void *)(-1))
		die("failed to mmap perf_event");

	close(fd);

	prof_stack_idx = 0;
}

static u64 first_count;

void prof_init(void) __attribute__((constructor));
void prof_init(void)
{
	char *event_str;

	page_size = sysconf(_SC_PAGESIZE);

	pthread_create_orig = dlsym(RTLD_NEXT, "pthread_create");
	if (!pthread_create_orig) {
		char *error = dlerror();
		if (!error)
			error = "pthread_create is NULL";
		die("%s\n", error);
	}

	memset(prof_arc_hash, 0, sizeof(prof_arc_hash));
	pthread_mutex_init(&prof_arc_lock, NULL);

	memset(prof_fn_hash, 0, sizeof(prof_fn_hash));
	pthread_mutex_init(&prof_fn_lock, NULL);

	event_str = getenv("PROF_EVENT");
	if (event_str)
		/* perf_attr = parse_attr_crap(event_str); */
		;

	thread_init(); /* main thread */

	first_count = mmap_read_self(perf_event);
}

struct prof_symbol {
	void *addr;
	unsigned long size;
	const char *name;
};

static struct prof_symbol *prof_symbols;
static unsigned long prof_nr_symbols;

static void prof_gelf(const char *name, void (*func)(Elf *elf, Elf_Scn *scn, GElf_Shdr *shdr, void *data), void *data)
{
	Elf         *elf;
	Elf_Scn     *scn = NULL;
	GElf_Shdr   shdr;
	int         fd;

	elf_version(EV_CURRENT);

	fd = open(name, O_RDONLY);
	elf = elf_begin(fd, ELF_C_READ, NULL);

	while ((scn = elf_nextscn(elf, scn)) != NULL) {
		gelf_getshdr(scn, &shdr);
		if (shdr.sh_type == SHT_SYMTAB) {
			func(elf, scn, &shdr, data);
		}
	}

	elf_end(elf);
	close(fd);
}

static void prof_gelf_nr_symbols(Elf *elf, Elf_Scn *scn, GElf_Shdr *shdr, void *data)
{
	unsigned long *nr_symbols = data;
	unsigned long count;

	count = shdr->sh_size / shdr->sh_entsize;
	*nr_symbols += count;
}

static int prof_count_symbols(struct dl_phdr_info *info, size_t size, void *data)
{
	prof_gelf(info->dlpi_name, prof_gelf_nr_symbols, data);
	return 0;
}

static void prof_gelf_load_symbols(Elf *elf, Elf_Scn *scn, GElf_Shdr *shdr, void *_info)
{
	struct dl_phdr_info *info = _info;
	unsigned long count = shdr->sh_size / shdr->sh_entsize;
	unsigned long i;
	Elf_Data *data;

	data = elf_getdata(scn, NULL);

	for (i = 0; i < count; i++) {
		GElf_Sym sym;
		char *name;
		struct prof_symbol *symbol = &prof_symbols[prof_nr_symbols];

		gelf_getsym(data, i, &sym);

		if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
			continue;

		if (!sym.st_size)
			continue;

		name = elf_strptr(elf, shdr->sh_link, sym.st_name);
		if (!name)
			continue;

		symbol->name = strdup(name);
		symbol->addr = (void *)(sym.st_value + info->dlpi_addr);
		symbol->size = sym.st_size;

		prof_nr_symbols++;
	}
}

static int prof_load_symbols(struct dl_phdr_info *info, size_t size, void *data)
{
	prof_gelf(info->dlpi_name, prof_gelf_load_symbols, info);
	return 0;
}

static int prof_cmp_symbol(const void *_a, const void *_b)
{
	const struct prof_symbol *a = _a, *b = _b;

	if (a->addr < b->addr)
		return -1;

	if (a->addr > b->addr)
		return 1;

	return 0;
}

static void load_symbols(void)
{
	unsigned long nr_symbols = 0;
	struct dl_phdr_info dl_info = {
		.dlpi_name = "/proc/self/exe",
		.dlpi_addr = 0,
	};

	prof_count_symbols(&dl_info, sizeof(dl_info), &nr_symbols);
	dl_iterate_phdr(prof_count_symbols, &nr_symbols);

	prof_symbols = calloc(nr_symbols, sizeof(struct prof_symbol));

	prof_load_symbols(&dl_info, sizeof(dl_info), NULL);
	dl_iterate_phdr(prof_load_symbols, NULL);

	qsort(prof_symbols, prof_nr_symbols, 
			sizeof(struct prof_symbol), prof_cmp_symbol);
}

static struct prof_symbol *find_symbol(void *addr)
{
	struct prof_symbol *sym;
	unsigned long l, u, i;

	l = 0;
	u = prof_nr_symbols;

	while (l < u) {
		i = (l + u) / 2;
		sym = &prof_symbols[i];

		if (addr >= sym->addr && addr < sym->addr + sym->size)
			return sym;

		if (addr < sym->addr)
			u = i;
		else
			l = i + 1;
	}

	return NULL;
}

void prof_exit(void) __attribute__((destructor));
void prof_exit(void)
{
	FILE *file;
	int i;
	int64_t max_fn_count = 0;

	load_symbols();

	file = fopen("prof.dot", "w");
	if (!file)
		die("failed to create output file");

	fprintf(file, "#\n# first count: %lu\n#\n", first_count);

	/*
	 * Maybe replace "profile" with the argv
	 */
	fprintf(file, "digraph profile {\n");

	for (i = 0; i < ARC_HASH_SIZE; i++) {
		struct prof_arc *arc = &prof_arc_hash[i];
		struct prof_symbol *c_sym, *t_sym;
		struct prof_fn *c;
		double p;

		if (!(arc->call_fn && arc->this_fn))
			continue;

		c_sym = find_symbol(arc->call_fn);
		t_sym = find_symbol(arc->this_fn);

		if (!c_sym || !t_sym)
			die("symbols missing");

		c = prof_fn_find(c_sym->addr);
		if (!c)
			die("fn_hash|symtab borken");

		p = (double)arc->count / (double)c->count;
		fprintf(file, 
		"  \"%s\" -> \"%s\" [label=\"%f\", color=\"%.3f %.3f %.3f\"]\n",
			c_sym->name, t_sym->name, 100.0 * p,
			0.33, 1.0, p);
	}

	for (i = 0; i < ARC_HASH_SIZE; i++) {
		struct prof_arc *arc = &prof_arc_hash[i];
		struct prof_symbol *c_sym;
		struct prof_fn *c;
		double p;

		if (!(arc->call_fn && arc->this_fn))
			continue;

		c_sym = find_symbol(arc->call_fn);
		c = prof_fn_find(c_sym->addr);

		c->count -= arc->count;
	}

	for (i = 0; i < FN_HASH_SIZE; i++) {
		struct prof_fn *fn = &prof_fn_hash[i];
		struct prof_symbol *s;

		if (!fn->this_fn)
			continue;

		if ((int64_t)fn->count > max_fn_count)
			max_fn_count = fn->count;

		s = find_symbol(fn->this_fn);
//		fprintf(file, "#  %s %ld\n", s->name, fn->count);
	}

	for (i = 0; i < FN_HASH_SIZE; i++) {
		struct prof_fn *fn = &prof_fn_hash[i];
		struct prof_symbol *s;
		double p;

		if (!fn->this_fn)
			continue;

		s = find_symbol(fn->this_fn);
		p = (double)fn->count / (double)max_fn_count;
		fprintf(file, "  \"%s\" [color=\"%.3f %.3f %.3f\"]\n", 
				s->name, 0.0, 1.0, p);
	}

	fprintf(file, "}\n");
	fflush(file);
	fclose(file);
}

struct tramp_data {

	void *(*func)(void *);
	void *arg;

	pthread_mutex_t lock;
	pthread_cond_t  wait;
};

static void *tramp_func(void *data)
{
	struct tramp_data *tramp_data = data;
	void *(*func)(void *) = tramp_data->func;
	void *arg = tramp_data->arg;
	void *ret;

	thread_init();

	pthread_mutex_lock(&tramp_data->lock);
	pthread_cond_signal(&tramp_data->wait);
	pthread_mutex_unlock(&tramp_data->lock);

	ret = func(arg);

	munmap(perf_event, page_size);

	return ret;
}

/* hijack pthread_create() */
int pthread_create(pthread_t *__restrict thread,
		__const pthread_attr_t *__restrict attr,
		void *(*func)(void *),
		void *__restrict arg)
{
	struct tramp_data tramp_data = {
		.func = func,
		.arg = arg,
	};
	int ret;

	pthread_cond_init(&tramp_data.wait, NULL);
	pthread_mutex_init(&tramp_data.lock, NULL);

	pthread_mutex_lock(&tramp_data.lock);

	ret = pthread_create_orig(thread, attr, &tramp_func, &tramp_data);
	if (!ret)
		pthread_cond_wait(&tramp_data.wait, &tramp_data.lock);

	pthread_mutex_unlock(&tramp_data.lock);

	pthread_mutex_destroy(&tramp_data.lock);
	pthread_cond_destroy(&tramp_data.wait);

	return ret;
} 

void __cyg_profile_func_enter(void *this_fn, void *call_fn)
{
	struct prof_stack *st = &prof_stack[prof_stack_idx++];

	st->arc = prof_arc_find(this_fn, call_fn);
	st->fn = prof_fn_find(this_fn);
	st->stamp = mmap_read_self(perf_event);
}

void __cyg_profile_func_exit(void *this_fn, void *call_fn)
{
	struct prof_stack *st = &prof_stack[--prof_stack_idx];
	uint64_t now, delta;

	now = mmap_read_self(perf_event);
	delta = now - st->stamp;
	(void)__sync_fetch_and_add(&st->fn->count, delta);
	(void)__sync_fetch_and_add(&st->arc->count, delta);
}
/*
 * Library to hook into code compiled with -finstrument-functions it will
 * record function arcs (call_fn, this_fn) as well as the sum of whatever event
 * is being measured over that function.
 *
 * Copyright (C) 2011 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
 *
 * This file is copyrighted under the GPLv2 License (and not any later version).
 *
 * SuperFastHash under LGPLv2.1 (http://www.azillionmonkeys.com/qed/hash.html)
 *
 * Compilation example:
 * gcc -shared -fPIC profviz.c -o profviz.so -lpthread -ldl -lelf
 *
 * Usage example:
 * LD_PRELOAD=./profviz.so your_program 
 */

#define _GNU_SOURCE

#include "util/util.h"
#include "perf.h"
#include "util/parse-events.h"

#include <sys/time.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <pthread.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <libelf.h>
#include <gelf.h>
#include <link.h>
#include <math.h>

#define barrier() asm volatile("" ::: "memory")

static u64 rdpmc(unsigned int counter)
{
	unsigned int low, high;

	asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));

	return low | ((u64)high) << 32;
}

static u64 rdtsc(void)
{
	unsigned int low, high;

	asm volatile("rdtsc" : "=a" (low), "=d" (high));

	return low | ((u64)high) << 32;
}

static u64 mmap_read_self(void *addr)
{
	struct perf_event_mmap_page *pc = addr;
	u32 seq, idx, time_mult = 0, time_shift = 0, width = 0;
	u64 count, cyc = 0, time_offset = 0, enabled, running, delta;
	s64 pmc = 0;

	do {
		seq = pc->lock;
		barrier();

		enabled = pc->time_enabled;
		running = pc->time_running;

		if (pc->cap_usr_time && enabled != running) {
			cyc = rdtsc();
			time_mult = pc->time_mult;
			time_shift = pc->time_shift;
			time_offset = pc->time_offset;
		}

		idx = pc->index;
		count = pc->offset;
		if (pc->cap_usr_rdpmc && idx) {
			width = pc->pmc_width;
			pmc = rdpmc(idx - 1);
		}

		barrier();
	} while (pc->lock != seq);

	if (idx) {
		pmc <<= 64 - width;
		pmc >>= 64 - width; /* shift right signed */
		count += pmc;
	}

	if (enabled != running) {
		u64 quot, rem;

		quot = (cyc >> time_shift);
		rem = cyc & ((1 << time_shift) - 1);
		delta = time_offset + quot * time_mult +
			((rem * time_mult) >> time_shift);

		enabled += delta;
		if (idx)
			running += delta;

		quot = count / running;
		rem = count % running;
		count = quot * enabled + (rem * enabled) / running;
	}

	return count;
}

static int (*pthread_create_orig)(pthread_t *__restrict,
		__const pthread_attr_t *__restrict,
		void *(*)(void *),
		void *__restrict) = NULL;

static struct perf_event_attr perf_attr = {
	.type = PERF_TYPE_HARDWARE,
	.config = PERF_COUNT_HW_CPU_CYCLES,
	.exclude_kernel = 1,
};

struct prof_arc {
	void *call_fn;
	void *this_fn;
	uint64_t count;
};

struct prof_fn {
	void *this_fn;
	uint64_t count;
};

#define get16bits(d) ((((uint32_t)(((const uint8_t *)(d))[1])) << 8) \
		                       +(uint32_t)(((const uint8_t *)(d))[0]) )

static uint32_t SuperFastHash (const char * data, int len, uint32_t hash) {
	uint32_t tmp;
	int rem;

	if (len <= 0 || data == NULL) return 0;

	rem = len & 3;
	len >>= 2;

	/* Main loop */
	for (;len > 0; len--) {
		hash  += get16bits (data);
		tmp    = (get16bits (data+2) << 11) ^ hash;
		hash   = (hash << 16) ^ tmp;
		data  += 2*sizeof (uint16_t);
		hash  += hash >> 11;
	}

	/* Handle end cases */
	switch (rem) {
		case 3: hash += get16bits (data);
			hash ^= hash << 16;
			hash ^= data[sizeof (uint16_t)] << 18;
			hash += hash >> 11;
			break;
		case 2: hash += get16bits (data);
			hash ^= hash << 11;
			hash += hash >> 17;
			break;
		case 1: hash += *data;
			hash ^= hash << 10;
			hash += hash >> 1;
	}

	/* Force "avalanching" of final 127 bits */
	hash ^= hash << 3;
	hash += hash >> 5;
	hash ^= hash << 4;
	hash += hash >> 17;
	hash ^= hash << 25;
	hash += hash >> 6;

	return hash;
}

void die(const char *err, ...)
{
	va_list params;

	va_start(params, err);
	vfprintf(stderr, err, params);
	va_end(params);

	exit(-1);
}


#define HASH_TABLE_SIZE		16384
#define AVG_STACK_DEPTH		8

#define ARC_HASH_SIZE	(HASH_TABLE_SIZE * AVG_STACK_DEPTH)

static struct prof_arc prof_arc_hash[ARC_HASH_SIZE];
static pthread_mutex_t prof_arc_lock;

#define FN_HASH_SIZE	(HASH_TABLE_SIZE)

static struct prof_fn  prof_fn_hash[FN_HASH_SIZE];
static pthread_mutex_t prof_fn_lock;

#define HASH_INIT		0x9e370001UL	
#define HASH_CHAIN		16

static inline void *
prof_hash_find(void *hash_base, const size_t hash_size, 
		const void *key, const size_t key_size,
		const size_t entry_size, pthread_mutex_t *lock)

{
	uint32_t hash = HASH_INIT;
	void *entry = NULL;
	int i, j;

	for (i = 0; i < HASH_CHAIN; i++) {
		hash = SuperFastHash(key, key_size, hash);
		entry = hash_base + entry_size * (hash % FN_HASH_SIZE);
		if (!memcmp(entry, key, key_size))
			return entry;

		for (j = 0; j < key_size; j++) {
			if (*((char *)entry + j))
				goto next_1;
		}

		goto found_empty;
next_1:
		continue;
	}
	die("fn_hash too full");

found_empty:
	hash = HASH_INIT;
	pthread_mutex_lock(lock);
	for (i = 0; i < HASH_CHAIN; i++) {
		hash = SuperFastHash(key, key_size, hash);
		entry = hash_base + entry_size * (hash % FN_HASH_SIZE);

		if (!memcmp(entry, key, key_size))
			goto unlock;

		for (j = 0; j < key_size; j++) {
			if (*((char *)entry + j))
				goto next_2;
		}

		memcpy(entry, key, key_size);
		goto unlock;
next_2:
		continue;
	}
	die("fn_hash too full (locked)");
unlock:
	pthread_mutex_unlock(lock);

	return entry;
}

static struct prof_fn *prof_fn_find(void *this_fn)
{
	return prof_hash_find(prof_fn_hash, FN_HASH_SIZE,
			&this_fn, sizeof(this_fn), sizeof(struct prof_fn),
			&prof_fn_lock);
}

static struct prof_arc *prof_arc_find(void *this_fn, void *call_fn)
{
	struct prof_arc arc = { .this_fn = this_fn, .call_fn = call_fn, };

	return prof_hash_find(prof_arc_hash, ARC_HASH_SIZE,
			&arc, 2*sizeof(void *), sizeof(struct prof_arc),
			&prof_arc_lock);
}

static unsigned long page_size;

struct prof_stack {
	struct prof_arc *arc;
	struct prof_fn *fn;
	uint64_t stamp;
};

static __thread struct prof_stack prof_stack[128];
static __thread int prof_stack_idx = 0;

static __thread void *perf_event;

static void thread_init(void)
{
	int fd;

	fd = sys_perf_event_open(&perf_attr, 0, -1, -1, 0);
	if (fd < 0)
		die("failed to create perf_event");

	perf_event = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
	if (perf_event == (void *)(-1))
		die("failed to mmap perf_event");

	close(fd);

	prof_stack_idx = 0;
}

static u64 first_count;

void prof_init(void) __attribute__((constructor));
void prof_init(void)
{
	char *event_str;

	page_size = sysconf(_SC_PAGESIZE);

	pthread_create_orig = dlsym(RTLD_NEXT, "pthread_create");
	if (!pthread_create_orig) {
		char *error = dlerror();
		if (!error)
			error = "pthread_create is NULL";
		die("%s\n", error);
	}

	memset(prof_arc_hash, 0, sizeof(prof_arc_hash));
	pthread_mutex_init(&prof_arc_lock, NULL);

	memset(prof_fn_hash, 0, sizeof(prof_fn_hash));
	pthread_mutex_init(&prof_fn_lock, NULL);

	event_str = getenv("PROF_EVENT");
	if (event_str)
		/* perf_attr = parse_attr_crap(event_str); */
		;

	thread_init(); /* main thread */

	first_count = mmap_read_self(perf_event);
}

struct prof_symbol {
	void *addr;
	unsigned long size;
	const char *name;
};

static struct prof_symbol *prof_symbols;
static unsigned long prof_nr_symbols;

static void prof_gelf(const char *name, void (*func)(Elf *elf, Elf_Scn *scn, GElf_Shdr *shdr, void *data), void *data)
{
	Elf         *elf;
	Elf_Scn     *scn = NULL;
	GElf_Shdr   shdr;
	int         fd;

	elf_version(EV_CURRENT);

	fd = open(name, O_RDONLY);
	elf = elf_begin(fd, ELF_C_READ, NULL);

	while ((scn = elf_nextscn(elf, scn)) != NULL) {
		gelf_getshdr(scn, &shdr);
		if (shdr.sh_type == SHT_SYMTAB) {
			func(elf, scn, &shdr, data);
		}
	}

	elf_end(elf);
	close(fd);
}

static void prof_gelf_nr_symbols(Elf *elf, Elf_Scn *scn, GElf_Shdr *shdr, void *data)
{
	unsigned long *nr_symbols = data;
	unsigned long count;

	count = shdr->sh_size / shdr->sh_entsize;
	*nr_symbols += count;
}

static int prof_count_symbols(struct dl_phdr_info *info, size_t size, void *data)
{
	prof_gelf(info->dlpi_name, prof_gelf_nr_symbols, data);
	return 0;
}

static void prof_gelf_load_symbols(Elf *elf, Elf_Scn *scn, GElf_Shdr *shdr, void *_info)
{
	struct dl_phdr_info *info = _info;
	unsigned long count = shdr->sh_size / shdr->sh_entsize;
	unsigned long i;
	Elf_Data *data;

	data = elf_getdata(scn, NULL);

	for (i = 0; i < count; i++) {
		GElf_Sym sym;
		char *name;
		struct prof_symbol *symbol = &prof_symbols[prof_nr_symbols];

		gelf_getsym(data, i, &sym);

		if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
			continue;

		if (!sym.st_size)
			continue;

		name = elf_strptr(elf, shdr->sh_link, sym.st_name);
		if (!name)
			continue;

		symbol->name = strdup(name);
		symbol->addr = (void *)(sym.st_value + info->dlpi_addr);
		symbol->size = sym.st_size;

		prof_nr_symbols++;
	}
}

static int prof_load_symbols(struct dl_phdr_info *info, size_t size, void *data)
{
	prof_gelf(info->dlpi_name, prof_gelf_load_symbols, info);
	return 0;
}

static int prof_cmp_symbol(const void *_a, const void *_b)
{
	const struct prof_symbol *a = _a, *b = _b;

	if (a->addr < b->addr)
		return -1;

	if (a->addr > b->addr)
		return 1;

	return 0;
}

static void load_symbols(void)
{
	unsigned long nr_symbols = 0;
	struct dl_phdr_info dl_info = {
		.dlpi_name = "/proc/self/exe",
		.dlpi_addr = 0,
	};

	prof_count_symbols(&dl_info, sizeof(dl_info), &nr_symbols);
	dl_iterate_phdr(prof_count_symbols, &nr_symbols);

	prof_symbols = calloc(nr_symbols, sizeof(struct prof_symbol));

	prof_load_symbols(&dl_info, sizeof(dl_info), NULL);
	dl_iterate_phdr(prof_load_symbols, NULL);

	qsort(prof_symbols, prof_nr_symbols, 
			sizeof(struct prof_symbol), prof_cmp_symbol);
}

static struct prof_symbol *find_symbol(void *addr)
{
	struct prof_symbol *sym;
	unsigned long l, u, i;

	l = 0;
	u = prof_nr_symbols;

	while (l < u) {
		i = (l + u) / 2;
		sym = &prof_symbols[i];

		if (addr >= sym->addr && addr < sym->addr + sym->size)
			return sym;

		if (addr < sym->addr)
			u = i;
		else
			l = i + 1;
	}

	return NULL;
}

void prof_exit(void) __attribute__((destructor));
void prof_exit(void)
{
	FILE *file;
	int i;
	int64_t max_fn_count = 0;

	load_symbols();

	file = fopen("prof.dot", "w");
	if (!file)
		die("failed to create output file");

	fprintf(file, "#\n# first count: %lu\n#\n", first_count);

	/*
	 * Maybe replace "profile" with the argv
	 */
	fprintf(file, "digraph profile {\n");

	for (i = 0; i < ARC_HASH_SIZE; i++) {
		struct prof_arc *arc = &prof_arc_hash[i];
		struct prof_symbol *c_sym, *t_sym;
		struct prof_fn *c;
		double p;

		if (!(arc->call_fn && arc->this_fn))
			continue;

		c_sym = find_symbol(arc->call_fn);
		t_sym = find_symbol(arc->this_fn);

		if (!c_sym || !t_sym)
			die("symbols missing");

		c = prof_fn_find(c_sym->addr);
		if (!c)
			die("fn_hash|symtab borken");

		p = (double)arc->count / (double)c->count;
		fprintf(file, 
		"  \"%s\" -> \"%s\" [label=\"%f\", color=\"%.3f %.3f %.3f\"]\n",
			c_sym->name, t_sym->name, 100.0 * p,
			0.33, 1.0, p);
	}

	for (i = 0; i < ARC_HASH_SIZE; i++) {
		struct prof_arc *arc = &prof_arc_hash[i];
		struct prof_symbol *c_sym;
		struct prof_fn *c;
		double p;

		if (!(arc->call_fn && arc->this_fn))
			continue;

		c_sym = find_symbol(arc->call_fn);
		c = prof_fn_find(c_sym->addr);

		c->count -= arc->count;
	}

	for (i = 0; i < FN_HASH_SIZE; i++) {
		struct prof_fn *fn = &prof_fn_hash[i];
		struct prof_symbol *s;

		if (!fn->this_fn)
			continue;

		if ((int64_t)fn->count > max_fn_count)
			max_fn_count = fn->count;

		s = find_symbol(fn->this_fn);
//		fprintf(file, "#  %s %ld\n", s->name, fn->count);
	}

	for (i = 0; i < FN_HASH_SIZE; i++) {
		struct prof_fn *fn = &prof_fn_hash[i];
		struct prof_symbol *s;
		double p;

		if (!fn->this_fn)
			continue;

		s = find_symbol(fn->this_fn);
		p = (double)fn->count / (double)max_fn_count;
		fprintf(file, "  \"%s\" [color=\"%.3f %.3f %.3f\"]\n", 
				s->name, 0.0, 1.0, p);
	}

	fprintf(file, "}\n");
	fflush(file);
	fclose(file);
}

struct tramp_data {

	void *(*func)(void *);
	void *arg;

	pthread_mutex_t lock;
	pthread_cond_t  wait;
};

static void *tramp_func(void *data)
{
	struct tramp_data *tramp_data = data;
	void *(*func)(void *) = tramp_data->func;
	void *arg = tramp_data->arg;
	void *ret;

	thread_init();

	pthread_mutex_lock(&tramp_data->lock);
	pthread_cond_signal(&tramp_data->wait);
	pthread_mutex_unlock(&tramp_data->lock);

	ret = func(arg);

	munmap(perf_event, page_size);

	return ret;
}

/* hijack pthread_create() */
int pthread_create(pthread_t *__restrict thread,
		__const pthread_attr_t *__restrict attr,
		void *(*func)(void *),
		void *__restrict arg)
{
	struct tramp_data tramp_data = {
		.func = func,
		.arg = arg,
	};
	int ret;

	pthread_cond_init(&tramp_data.wait, NULL);
	pthread_mutex_init(&tramp_data.lock, NULL);

	pthread_mutex_lock(&tramp_data.lock);

	ret = pthread_create_orig(thread, attr, &tramp_func, &tramp_data);
	if (!ret)
		pthread_cond_wait(&tramp_data.wait, &tramp_data.lock);

	pthread_mutex_unlock(&tramp_data.lock);

	pthread_mutex_destroy(&tramp_data.lock);
	pthread_cond_destroy(&tramp_data.wait);

	return ret;
} 

void __cyg_profile_func_enter(void *this_fn, void *call_fn)
{
	struct prof_stack *st = &prof_stack[prof_stack_idx++];

	st->arc = prof_arc_find(this_fn, call_fn);
	st->fn = prof_fn_find(this_fn);
	st->stamp = mmap_read_self(perf_event);
}

void __cyg_profile_func_exit(void *this_fn, void *call_fn)
{
	struct prof_stack *st = &prof_stack[--prof_stack_idx];
	uint64_t now, delta;

	now = mmap_read_self(perf_event);
	delta = now - st->stamp;
	(void)__sync_fetch_and_add(&st->fn->count, delta);
	(void)__sync_fetch_and_add(&st->arc->count, delta);
}


