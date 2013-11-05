Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3KEG60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:58:26 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51004 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3KEG6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:58:25 -0500
X-AuditID: 9c930197-b7b60ae000006860-31-5278970e868c
From: Namhyung Kim <namhyung@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/13] tracing/uprobes: Add support for more fetch methods (v6)
References: <1383029621-7384-1-git-send-email-namhyung@kernel.org>
	<20131102155458.GA6981@redhat.com> <87ob60366m.fsf@sejong.aot.lge.com>
	<87fvrc35kj.fsf@sejong.aot.lge.com> <20131104155131.GD4440@redhat.com>
	<20131104162229.GA8921@redhat.com> <20131104184741.GA15945@redhat.com>
Date: Tue, 05 Nov 2013 15:58:22 +0900
In-Reply-To: <20131104184741.GA15945@redhat.com> (Oleg Nesterov's message of
	"Mon, 4 Nov 2013 19:47:41 +0100")
Message-ID: <87sivbz65t.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I have for now:

static void __user *get_user_vaddr(struct pt_regs *regs, unsigned long addr,
				   struct trace_uprobe *tu)
{
	unsigned long base_addr;
	unsigned long vaddr;

	base_addr = instruction_pointer(regs) - tu->offset;
	vaddr = base_addr + addr;

	return (void __force __user *) vaddr;
}

When I tested it, it was able to fetch global and bss data from both of
executable and library properly.  But it still doesn't work for uretprobes
as you said before.

  # perf probe -x ./uprobe-test -a "t1=test1 bss=@0x203000:s32 global=@0x201250:s32 str=@0x201254:string"
  # perf probe -x ./uprobe-test -a "t2=test2 bss=@0x203000:s32 global=@0x201250:s32 str=@0x201254:string"
  # perf probe -x ./uprobe-test -a "t3=test3 bss=@0x203000:s32 global=@0x201250:s32 str=@0x201254:string"
  # perf probe -x ./libfoo.so -a "t4=foo1 bar=@0x201258:s32 baz=@0x203000:s32"
  # perf probe -x ./libfoo.so -a "t5=foo2 bar=@0x201258:s32 baz=@0x203000:s32"
  # perf probe -x ./libfoo.so -a "t6=foo3 bar=@0x201258:s32 baz=@0x203000:s32"
  # perf record -e probe_uprobe:* -e probe_libfoo:* -- ./uprobe-test

  # perf script | grep -v ^#
     uprobe-test  2997 [002] 13108.308952: probe_uprobe:t1: (400660) bss=0 global=1 str="hello uprobe"
     uprobe-test  2997 [002] 13108.322479: probe_uprobe:t2: (400666) bss=0 global=2 str="hello uprobe"
     uprobe-test  2997 [002] 13108.335552: probe_uprobe:t3: (40066c) bss=1 global=2 str="hello uprobe"
     uprobe-test  2997 [002] 13108.342182: probe_libfoo:t4: (7f5eb977b798) bar=7 baz=0
     uprobe-test  2997 [002] 13108.348982: probe_libfoo:t5: (7f5eb977b79e) bar=8 baz=0
     uprobe-test  2997 [002] 13108.356041: probe_libfoo:t6: (7f5eb977b7a4) bar=8 baz=9


As you can see symbol offset passed to the uprobes now look like 0x203000
since it's the difference to the base mapping address.  For a dso, it's same
as the symbol value, but for an executable the symbol value would be larger
value like 0x603000 since the text segment would be mapped to 0x400000.
But still the difference is same, and I believe this applies to the
randomization too.

This symbol offset calculation was done in the getsymoff which implemented
like below (I'm sure there's a much simpler way to do this, but ...).

And I revised my toy test program like this:


/* ----- 8< ----- test.c ----- 8< ----- */
#include <stdio.h>
#include <stdlib.h>

int global = 1;
char str[] = "hello uprobe";
int bss __attribute__((aligned(4096)));

/* this came from libfoo.so */
extern void foo(void);

void test1(void)
{
  /* only for adding probe */
}

void test2(void)
{
  /* only for adding probe */
}

void test3(void)
{
  /* only for adding probe */
}

int main(void)
{
  int local = 3;
  char buf[128];

  test1();
  global = 2;
  test2();
  bss = 1;
  test3();
  foo();
  //  snprintf(buf, sizeof(buf), "cat /proc/%d/maps", getpid());
  //  system(buf);
  return 0;
}


/* ----- 8< ----- foo.c ----- 8< ----- */
int bar = 7;
int baz __attribute__((aligned(4096)));

void foo1(void)
{
  /* only for adding probe */
}

void foo2(void)
{
  /* only for adding probe */
}

void foo3(void)
{
  /* only for adding probe */
}

void foo(void)
{
  foo1();
  bar = 8;
  foo2();
  baz = 9;
  foo3();
}


/* ----- 8< ----- Makefile ----- 8< ----- */
PERF=/home/namhyung/project/linux/tools/perf/perf
GETSYMOFF=./getsymoff

define make-args
$(eval ARG1 := $(shell echo "bss=@`${GETSYMOFF} uprobe-test bss`:s32"))
$(eval ARG2 := $(shell echo "global=@`${GETSYMOFF} uprobe-test global`:s32"))
$(eval ARG3 := $(shell echo "str=@`${GETSYMOFF} uprobe-test str`:string"))
$(eval ARG4 := $(shell echo "bar=@`${GETSYMOFF} libfoo.so bar`:s32"))
$(eval ARG5 := $(shell echo "baz=@`${GETSYMOFF} libfoo.so baz`:s32"))
endef

all: uprobe-test

uprobe-test: test.c foo.c
	gcc -shared -g -fpic -o libfoo.so foo.c
	gcc -g -o $@ test.c -Wl,-rpath,. -L. -lfoo

getsymoff: getsymoff.c
	gcc -g -o $@ getsymoff.c -lelf

test: uprobe-test getsymoff
	$(call make-args)
	${PERF} probe -x ./uprobe-test -a "t1=test1 ${ARG1} ${ARG2} ${ARG3}"
	${PERF} probe -x ./uprobe-test -a "t2=test2 ${ARG1} ${ARG2} ${ARG3}"
	${PERF} probe -x ./uprobe-test -a "t3=test3 ${ARG1} ${ARG2} ${ARG3}"
	${PERF} probe -x ./libfoo.so -a "t4=foo1 ${ARG4} ${ARG5}"
	${PERF} probe -x ./libfoo.so -a "t5=foo2 ${ARG4} ${ARG5}"
	${PERF} probe -x ./libfoo.so -a "t6=foo3 ${ARG4} ${ARG5}"
	${PERF} record -e probe_uprobe:* -e probe_libfoo:* -- ./uprobe-test
	${PERF} script | grep -v ^#
	${PERF} probe -d probe_uprobe:*
	${PERF} probe -d probe_libfoo:*

clean:
	rm -f uprobe-test libfoo.so getsymoff *.o *~
#	${PERF} probe -d probe_uprobe:* -d probe_libfoo:*


/* ----- 8< ----- getsymoff.c ----- 8< ----- */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <gelf.h>

struct sym {
	unsigned long addr;
	unsigned long size;
	char *name;
};

#define SYMTAB_GROW  16

struct symtab {
	struct sym *sym;
	size_t nr_sym;
	size_t nr_alloc;
};

static struct symtab symtab;

static unsigned long base_addr;

static void usage(void)
{
	printf("Usage: %s <file> <symbol>\n", program_invocation_short_name);
	exit(0);
}

static int symsort(const void *a, const void *b)
{
	const struct sym *syma = a;
	const struct sym *symb = b;
	return strcmp(syma->name, symb->name);
}

static int symfind(const void *a, const void *b)
{
	const struct sym *sym = b;
	return strcmp(a, sym->name);
}

static int get_base_addr(Elf *elf)
{
	GElf_Ehdr ehdr;
	GElf_Phdr phdr;
	size_t i;

	if (gelf_getehdr(elf, &ehdr) == NULL)
		return -1;

	for (i = 0; i < ehdr.e_phnum; i++) {
		if (gelf_getphdr(elf, i, &phdr) == NULL)
			return -1;
		if (phdr.p_type != PT_LOAD)
			continue;

		/* use first loadable segment for the base address */
		base_addr = phdr.p_vaddr - phdr.p_offset;
		return 0;
	}
	return -1;
}

static int load_symtab(Elf *elf)
{
	int ret = -1;
	size_t shstr_idx;
	Elf_Scn *shstr_sec, *sym_sec, *str_sec;
	Elf_Data *shstr_data, *sym_data, *str_data;
	Elf_Scn *sec;
	Elf_Data *data;
	size_t i, nr_sym;

	if (elf_getshdrstrndx(elf, &shstr_idx) < 0)
		goto error;

	shstr_sec = elf_getscn(elf, shstr_idx);
	if (shstr_sec == NULL)
		goto error;

	shstr_data = elf_getdata(shstr_sec, NULL);
	if (shstr_data == NULL)
		goto error;

	sec = sym_sec = str_sec = NULL;
	while ((sec = elf_nextscn(elf, sec)) != NULL) {
		char *shstr;
		GElf_Shdr shdr;

		if (gelf_getshdr(sec, &shdr) == NULL)
			goto error;

		shstr = ((char *)shstr_data->d_buf) + shdr.sh_name;

		if (strcmp(shstr, ".symtab") == 0) {
			sym_sec = sec;
			nr_sym = shdr.sh_size / shdr.sh_entsize;
		}
		if (strcmp(shstr, ".strtab") == 0)
			str_sec = sec;
	}

	if (sym_sec == NULL || str_sec == NULL) {
		printf("%s: cannot find symbol information.  Is it stripped?\n",
		       __func__);
		goto out;
	}

	sym_data = elf_getdata(sym_sec, NULL);
	str_data = elf_getdata(str_sec, NULL);

	if (sym_data == NULL || str_data == NULL) {
		printf("%s: cannot find symbol information\n", __func__);
		goto error;
	}

	symtab.sym = NULL;
	symtab.nr_sym = 0;
	symtab.nr_alloc = 0;

	for (i = 0; i < nr_sym; i++) {
		GElf_Sym elf_sym;
		struct sym *sym;
		char *name;

		if (symtab.nr_sym >= symtab.nr_alloc) {
			symtab.nr_alloc += SYMTAB_GROW;
			symtab.sym = realloc(symtab.sym,
					     symtab.nr_alloc * sizeof(*sym));

			if (symtab.sym == NULL) {
				perror("load_symtab: realloc");
				goto out;
			}
		}
		if (gelf_getsym(sym_data, i, &elf_sym) == NULL)
			goto error;
		if (elf_sym.st_size == 0)
			continue;

		sym = &symtab.sym[symtab.nr_sym++];

		name = ((char *)str_data->d_buf) + elf_sym.st_name;
		sym->addr = elf_sym.st_value;
		sym->size = elf_sym.st_size;
		sym->name = strdup(name);
		if (sym->name == NULL) {
			perror("load_symtab: strdup");
			goto out;
		}	
	}

	qsort(symtab.sym, symtab.nr_sym, sizeof(*symtab.sym), symsort);
	ret = 0;

out:
	return ret;

error:
	printf("%s: %s\n", __func__, elf_errmsg(elf_errno()));
	goto out;
}

static struct sym * find_symtab(const char *name)
{
	return bsearch(name, symtab.sym, symtab.nr_sym,
		       sizeof(*symtab.sym), symfind);
}

static void unload_symtab(void)
{
	size_t i;

	for (i = 0; i < symtab.nr_sym; i++) {
		struct sym *sym = symtab.sym + i;
		free(sym->name);
	}

	free(symtab.sym);
}

int main(int argc, char *argv[])
{
	int fd;
	char *filename;
	char *symbol;
	Elf *elf;
	struct sym *sym;

	if (argc < 3)
		usage();

	filename = argv[1];
	symbol = argv[2];

	elf_version(EV_CURRENT);

	fd = open(filename, O_RDONLY);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
	if (elf == NULL) {
		printf("%s: %s\n", __func__, elf_errmsg(elf_errno()));
		goto out;
	}

	if (get_base_addr(elf) < 0)
		goto out_error;

	if (load_symtab(elf) < 0)
		goto out_error;

	sym = find_symtab(symbol);

	if (sym)
		printf("%#lx\n", sym->addr - base_addr);
	else
		printf("cannot find symbol: %s\n", symbol);

out_error:
	unload_symtab();
	elf_end(elf);
out:
	close(fd);
	return 0;
}
