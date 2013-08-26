Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3HZMpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:45:15 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:51839 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3HZMpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:45:13 -0400
Message-ID: <521B4DD6.6090808@linux.vnet.ibm.com>
Date: Mon, 26 Aug 2013 14:45:10 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Frantisek Hrbata <fhrbata@redhat.com>
CC: linux-kernel@vger.kernel.org, jstancek@redhat.com, keescook@chromium.org,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com
Subject: Re: [RFC PATCH 2/4] gcov: add support for gcc 4.7 gcov format
References: <1377247176-13537-1-git-send-email-fhrbata@redhat.com> <1377247176-13537-3-git-send-email-fhrbata@redhat.com> <52177BD3.1020303@linux.vnet.ibm.com> <20130823210015.GA2352@localhost.localdomain>
In-Reply-To: <20130823210015.GA2352@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082612-4966-0000-0000-000006B0CD82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.08.2013 23:00, Frantisek Hrbata wrote:
> On Fri, Aug 23, 2013 at 05:12:19PM +0200, Peter Oberparleiter wrote:
>> On 23.08.2013 10:39, Frantisek Hrbata wrote:
>>> The gcov in-memory format changed in gcc 4.7. The biggest change, which
>>> requires this special implementation, is that gcov_info no longer contains
>>> array of counters for each counter type for all functions and gcov_fn_info is
>>> not used for mapping of function's counters to these arrays(offset). Now each
>>> gcov_fn_info contans it's counters, which makes things a little bit easier.
>>
>> By now I've come to the conclusion that I may have over-engineered
>> gcov_iter_next in the original GCC 3.4 implementation. This became especially
>> apparent when someone tried to adjust that code to also work with a specific
>> android GCC version - adding a simple field to the output file format required
>> major complex changes.
>>
>> Therefore in my version of the GCC 4.7 support, I opted to replace this logic
>> with the simpler approach of generating the gcov data file in-memory during
>> open (gcov_iter_new) and reducing gcov_iter_next/gcov_iter_write to simple
>> copy-from-buffer functions.
> 
> Yes, this seems reasonable and much easier approach to me, but we will end up
> with three copies of one gcov(gcda) file data in memory: data from gcc, our
> buffer and the buffer in seq file. But I guess this is not a big problem,
> unless someone opens a huge amount of gcda files in parallel. Generally I
> like this idea. This will be also probably faster then writing 1 or 2 ints per
> one iter write.

You're right about the data being in multiple buffers for the time that a .gcda
file is opened, but as you mentioned, this shouldn't be a problem since usually
only one .gcda file is open at a time. Also the reduction in code complexity is
in my opinion well worth it.

>> Since I can see the need to change the format code again in the future,
>> I think it would be easier to simplify this part of the code correspondingly.
>> I'm adding my version of this part of the implementation as discussion input
>> below (the relevant part starts at convert_to_gcda()).
> 
> I have really only two nits to the code(please see below). I spent some time
> checking the new seq/iter implementation and it seems ok to me. Generally I like
> how simple this change is done.
> 
>>
>> ---
>> kernel: gcov: add support for gcc 4.7 gcov format
>>
>> GCC 4.7 changed the format of gcov related data structures, both
>> on-disk and in memory. Add support for the new format.
>>
>> Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
>> ---
>>  kernel/gcov/Makefile  |    4
>>  kernel/gcov/gcc_4_7.c |  510 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 513 insertions(+), 1 deletion(-)
>>
>> --- a/kernel/gcov/Makefile
>> +++ b/kernel/gcov/Makefile
>> @@ -1,3 +1,5 @@
>>  ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
>>
>> -obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o gcc_3_4.o
>> +obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o
>> +obj-$(CONFIG_GCOV_KERNEL) += $(call cc-ifversion, -lt, 0407, gcc_3_4.o)
>> +obj-$(CONFIG_GCOV_KERNEL) += $(call cc-ifversion, -ge, 0407, gcc_4_7.o)
>> --- /dev/null
>> +++ b/kernel/gcov/gcc_4_7.c
>> @@ -0,0 +1,510 @@
>> +/*
>> + *  This code provides functions to handle gcc's profiling data format
>> + *  introduced with gcc 4.7. Future versions of gcc may change the gcov
>> + *  format (as happened before), so all format-specific information needs
>> + *  to be kept modular and easily exchangeable.
>> + *
>> + *  This file is based on gcc-internal definitions. Functions and data
>> + *  structures are defined to be compatible with gcc counterparts.
>> + *  For a better understanding, refer to gcc source: gcc/gcov-io.h.
>> + *
>> + *    Copyright IBM Corp. 2013
>> + *    Author(s): Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
>> + *
>> + *    Uses gcc-internal data definitions.
>> + */
>> +
>> +#include <linux/errno.h>
>> +#include <linux/slab.h>
>> +#include <linux/string.h>
>> +#include <linux/seq_file.h>
>> +#include <linux/vmalloc.h>
>> +#include <linux/types.h>
>> +#include "gcov.h"
>> +
>> +/*
>> + * Profiling data types used for gcc 4.7 and above - these are defined by
>> + * gcc and need to be kept as close to the original definition as possible to
>> + * remain compatible.
>> + */
>> +#define GCOV_COUNTERS		8
>> +#define GCOV_DATA_MAGIC		((unsigned int) 0x67636461)
>> +#define GCOV_TAG_FUNCTION	((unsigned int) 0x01000000)
>> +#define GCOV_TAG_COUNTER_BASE	((unsigned int) 0x01a10000)
>> +#define GCOV_TAG_FOR_COUNTER(count)					\
>> +	(GCOV_TAG_COUNTER_BASE + ((unsigned int) (count) << 17))
>> +
>> +#if BITS_PER_LONG >= 64
>> +typedef long gcov_type;
>> +#else
>> +typedef long long gcov_type;
>> +#endif
>> +
>> +/**
>> + * struct gcov_ctr_info - profiling data per function and counter type
>> + * @num: number of counter values for this type
>> + * @values: array of counter values for this type
>> + *
>> + * This data is generated by gcc during compilation and doesn't change
>> + * at run-time with the exception of the values array.
>> + */
>> +struct gcov_ctr_info {
>> +	unsigned int	num;
>> +	gcov_type	*values;
>> +};
>> +
>> +/**
>> + * struct gcov_fn_info - profiling meta data per function
>> + * @key: comdat key
>> + * @ident: object file-unique function identifier
>> + * @lineno_checksum: function lineno_checksum
>> + * @cfg_checksum: function cfg_checksum
>> + * @ctrs: counters
>> + *
>> + * This data is generated by gcc during compilation and doesn't change
>> + * at run-time.
>> + */
>> +struct gcov_fn_info {
>> +	const struct gcov_info *key;
>> +	unsigned int ident;
>> +	unsigned int lineno_checksum;
>> +	unsigned int cfg_checksum;
>> +	struct gcov_ctr_info ctrs[0];
>> +};
>> +
>> +typedef void (*gcov_merge_fn)(gcov_type *, unsigned int);
>> +
>> +/**
>> + * struct gcov_info - profiling data per object file
>> + * @version: gcov version magic indicating the gcc version used for compilation
>> + * @next: list head for a singly-linked list
>> + * @stamp: time stamp
>> + * @filename: name of the associated gcov data file
>> + * @merge: functions for merging counts per counter type or null for unused
>> + * @n_functions: number of instrumented functions
>> + * @functions: function data
>> + *
>> + * This data is generated by gcc during compilation and doesn't change
>> + * at run-time with the exception of the next pointer.
>> + */
>> +struct gcov_info {
>> +	unsigned int			version;
>> +	struct gcov_info		*next;
>> +	unsigned int			stamp;
>> +	const char			*filename;
>> +	gcov_merge_fn			merge[GCOV_COUNTERS];
>> +	unsigned int			n_functions;
>> +	struct gcov_fn_info		**functions;
> 
> I can see that you removed the const part. I was thinking about it too, because
> it requires ugly cast-const-away code in the gcov_info_dup and it is imho not
> necessary, but I left the original definition from gcc anyway.

The kernel's usage of gcov_info is slightly different from the GCC's internal
one, so a slight divergence should be ok from my point of view, especially
considering that the outcome (dropping a const declaration) is the same.

> 
>> +};
>> +
>> +/* Symbolic links to be created for each profiling data file. */
>> +const struct gcov_link gcov_link[] = {
>> +	{ OBJ_TREE, "gcno" },	/* Link to .gcno file in $(objtree). */
>> +	{ 0, NULL},
>> +};
>> +
>> +/*
>> + * Determine whether a counter is active. Based on gcc magic. Doesn't change
>> + * at run-time.
>> + */
>> +static int counter_active(struct gcov_info *info, unsigned int type)
>> +{
>> +	return info->merge[type] != NULL;
>> +}
>> +
>> +/* Determine number of active counters. Based on gcc magic. */
>> +static unsigned int num_counter_active(struct gcov_info *info)
>> +{
>> +	unsigned int i;
>> +	unsigned int result = 0;
>> +
>> +	for (i = 0; i < GCOV_COUNTERS; i++) {
>> +		if (counter_active(info, i))
>> +			result++;
>> +	}
>> +	return result;
>> +}
>> +
>> +/**
>> + * gcov_info_reset - reset profiling data to zero
>> + * @info: profiling data set
>> + */
>> +void gcov_info_reset(struct gcov_info *info)
>> +{
>> +	unsigned int active = num_counter_active(info);
>> +	unsigned int f, i;
>> +	struct gcov_ctr_info *ctr;
>> +
>> +	for (f = 0; f < info->n_functions; f++) {
>> +		for (i = 0; i < active; i++) {
>> +			ctr = &info->functions[f]->ctrs[i];
>> +			memset(ctr->values, 0, ctr->num * sizeof(gcov_type));
>> +		}
>> +	}
>> +}
>> +
>> +/**
>> + * gcov_info_is_compatible - check if profiling data can be added
>> + * @info1: first profiling data set
>> + * @info2: second profiling data set
>> + *
>> + * Returns non-zero if profiling data can be added, zero otherwise.
>> + */
>> +int gcov_info_is_compatible(struct gcov_info *info1, struct gcov_info *info2)
>> +{
>> +	return (info1->stamp == info2->stamp);
>> +}
>> +
>> +/**
>> + * gcov_info_add - add up profiling data
>> + * @dest: profiling data set to which data is added
>> + * @source: profiling data set which is added
>> + *
>> + * Adds profiling counts of @source to @dest.
>> + */
>> +void gcov_info_add(struct gcov_info *dest, struct gcov_info *source)
>> +{
>> +	unsigned int active = num_counter_active(dest);
>> +	unsigned int f, i, j;
>> +
>> +	for (f = 0; f < dest->n_functions; f++) {
>> +		for (i = 0; i < active; i++) {
>> +			struct gcov_ctr_info *d_ctr =
>> +				&dest->functions[f]->ctrs[i];
>> +			struct gcov_ctr_info *s_ctr =
>> +				&source->functions[f]->ctrs[i];
>> +
>> +			for (j = 0; j < d_ctr->num; j++) {
>> +				d_ctr->values[j] += s_ctr->values[j];
>> +			}
>> +		}
>> +	}
>> +}
>> +
>> +/**
>> + * gcov_info_dup - duplicate profiling data set
>> + * @info: profiling data set to duplicate
>> + *
>> + * Return newly allocated duplicate on success, %NULL on error.
>> + */
>> +struct gcov_info *gcov_info_dup(struct gcov_info *info)
>> +{
>> +	struct gcov_info *dup;
>> +	unsigned int active = num_counter_active(info);
>> +	unsigned int i, j;
>> +
>> +	/* Duplicate gcov_info. */
>> +	dup = kzalloc(sizeof(struct gcov_info), GFP_KERNEL);
>> +	if (!dup)
>> +		return NULL;
>> +	dup->version		= info->version;
>> +	dup->stamp		= info->stamp;
>> +	dup->n_functions	= info->n_functions;
>> +	memcpy(dup->merge, info->merge, sizeof(dup->merge));
>> +	/* Duplicate filename. */
>> +	dup->filename		= kstrdup(info->filename, GFP_KERNEL);
>> +	if (!dup->filename)
>> +		goto err_free;
>> +	/* Duplicate table of functions. */
>> +	dup->functions = kzalloc(sizeof(struct gcov_fn_info *) *
>> +				 info->n_functions, GFP_KERNEL);
>> +	if (!dup->functions)
>> +		goto err_free;
>> +	for (i = 0; i < info->n_functions; i++) {
>> +		struct gcov_fn_info *src_fn = info->functions[i];
>> +		struct gcov_fn_info *dest_fn;
>> +
>> +		/* Duplicate gcov_fn_info. */
>> +		dup->functions[i] = kzalloc(sizeof(struct gcov_fn_info) +
>> +					    sizeof(struct gcov_ctr_info) *
>> +					    active, GFP_KERNEL);
>> +		if (!dup->functions[i])
>> +			goto err_free;
>> +		dest_fn = dup->functions[i];
>> +		dest_fn->ident			= src_fn->ident;
>> +		dest_fn->lineno_checksum	= src_fn->lineno_checksum;
>> +		dest_fn->cfg_checksum		= src_fn->cfg_checksum;
>> +
>> +		for (j = 0; j < active; j++) {
>> +			struct gcov_ctr_info *src_ctr = &src_fn->ctrs[j];
>> +			struct gcov_ctr_info *dest_ctr = &dest_fn->ctrs[j];
>> +			size_t size = sizeof(gcov_type) * src_ctr->num;
>> +
>> +			/* Duplicate gcov_ctr_info. */
>> +			dest_ctr->num		= src_ctr->num;
>> +			dest_ctr->values	= vmalloc(size);
>                                                   ^^^^^^^
> Does the vmalloc make sense here? The counters are allocated per function, so I
> expect they will be pretty small compared when there was one "huge" array for
> each counter type for all functions per gcov_info. Meaning here we will not
> consume a "big" continuous block of phys memory. I'm just currious and maybe I'm
> missing something. Anyway this is just a nit.

Good point. Previously the sizes to be allocated here could be as large as 64k.
Now the largest I see for 3.10 on an s390x system is ~3k. On the other hand
since we're not on a performance critical path, staying with vmalloc might just
be safer.

>> +			if (!dest_ctr->values)
>> +				goto err_free;
>> +			memcpy(dest_ctr->values, src_ctr->values, size);
>> +		}
>> +	}
>> +	return dup;
>> +
>> +err_free:
>> +	gcov_info_free(dup);
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * gcov_info_free - release memory for profiling data set duplicate
>> + * @info: profiling data set duplicate to free
>> + */
>> +void gcov_info_free(struct gcov_info *info)
>> +{
>> +	unsigned int active = num_counter_active(info);
>> +	unsigned int i, j;
>> +
>> +	if (info->functions) {
>> +		for (i = 0; i < info->n_functions; i++) {
>> +			if (!info->functions[i])
>> +				continue;
>> +			for (j = 0; j < active; j++)
>> +				vfree(info->functions[i]->ctrs[j].values);
>> +			kfree(info->functions[i]);
>> +		}
>> +	}
>> +	kfree(info->functions);
>> +	kfree(info->filename);
>> +	kfree(info);
>> +}
>> +
>> +#define ITER_STRIDE	PAGE_SIZE
>> +
>> +/**
>> + * struct gcov_iterator - specifies current file position in logical records
>> + * @buffer: buffer containing file data
>> + * @size: size of buffer
>> + * @pos: current position in file
>> + */
>> +struct gcov_iterator {
>> +	struct gcov_info *info;
>> +	void *buffer;
>> +	size_t size;
>> +	loff_t pos;
>> +};
>> +
>> +/**
>> + * store_gcov_u32 - store 32 bit number in gcov format to buffer
>> + * @buffer: target buffer or NULL
>> + * @off: offset into the buffer
>> + * @v: value to be stored
>> + *
>> + * Number format defined by gcc: numbers are recorded in the 32 bit
>> + * unsigned binary form of the endianness of the machine generating the
>> + * file. Returns the number of bytes stored. If @buffer is %NULL, doesn't
>> + * store anything.
>> + */
>> +static size_t store_gcov_u32(void *buffer, size_t off, u32 v)
>> +{
>> +	u32 *data;
>> +
>> +	if (buffer) {
>> +		data = buffer + off;
>> +		*data = v;
>> +	}
>> +
>> +	return sizeof(*data);
>> +}
>> +
>> +/**
>> + * store_gcov_u64 - store 64 bit number in gcov format to buffer
>> + * @buffer: target buffer or NULL
>> + * @off: offset into the buffer
>> + * @v: value to be stored
>> + *
>> + * Number format defined by gcc: numbers are recorded in the 32 bit
>> + * unsigned binary form of the endianness of the machine generating the
>> + * file. 64 bit numbers are stored as two 32 bit numbers, the low part
>> + * first. Returns the number of bytes stored. If @buffer is %NULL, doesn't store
>> + * anything.
>> + */
>> +static size_t store_gcov_u64(void *buffer, size_t off, u64 v)
>> +{
>> +	u32 *data;
>> +
>> +	if (buffer) {
>> +		data = buffer + off;
>> +
>> +		data[0] = (v & 0xffffffffUL);
>> +		data[1] = (v >> 32);
>> +	}
>> +
>> +	return sizeof(*data) * 2;
>> +}
>> +
>> +/**
>> + * get_ctr_type - return type of specified counter
>> + * @info: profiling data set
>> + * @num: index into list of active counters
>> + *
>> + * Returns the type of the specified counter.
>> + */
>> +static int get_ctr_type(struct gcov_info *info, unsigned int num)
>> +{
>> +	unsigned int type;
>> +
>> +	for (type = 0; type < GCOV_COUNTERS; type++) {
>> +		if (counter_active(info, type)) {
>> +			if (num == 0)
>> +				break;
>> +			num--;
>> +		}
>> +	}
>> +
>> +	return type;
>> +}
>> +
>> +/**
>> + * convert_to_gcda - convert profiling data set to gcda file format
>> + * @buffer: the buffer to store file data or %NULL if no data should be stored
>> + * @info: profiling data set to be converted
>> + *
>> + * Returns the number of bytes that were/would have been stored into the buffer.
>> + */
>> +static size_t convert_to_gcda(char *buffer, struct gcov_info *info)
>> +{
>> +	unsigned int active = num_counter_active(info);
>> +	unsigned int i, j, k;
>> +	size_t pos = 0;
>> +
>> +	/* File header. */
>> +	pos += store_gcov_u32(buffer, pos, GCOV_DATA_MAGIC);
>> +	pos += store_gcov_u32(buffer, pos, info->version);
>> +	pos += store_gcov_u32(buffer, pos, info->stamp);
>> +
>> +	for (i = 0; i < info->n_functions; i++) {
>> +		struct gcov_fn_info *fn = info->functions[i];
>> +
>> +		/* Function record. */
>> +		pos += store_gcov_u32(buffer, pos, GCOV_TAG_FUNCTION);
>> +		pos += store_gcov_u32(buffer, pos, 3);
>> +		pos += store_gcov_u32(buffer, pos, fn->ident);
>> +		pos += store_gcov_u32(buffer, pos, fn->lineno_checksum);
>> +		pos += store_gcov_u32(buffer, pos, fn->cfg_checksum);
>> +
>> +		for (j = 0; j < active; j++) {
>> +			struct gcov_ctr_info *ctr = &fn->ctrs[j];
>> +			int type = get_ctr_type(info, j);
>> +
>> +			/* Counter record. */
>> +			pos += store_gcov_u32(buffer, pos,
>> +					      GCOV_TAG_FOR_COUNTER(type));
>> +			pos += store_gcov_u32(buffer, pos, ctr->num * 2);
>> +
>> +			for (k = 0; k < ctr->num; k++) {
>> +				pos += store_gcov_u64(buffer, pos,
>> +						      ctr->values[k]);
>> +			}
>> +		}
>> +
>> +
>> +	}
>> +
>> +	return pos;
>> +}
>> +
>> +/**
>> + * gcov_iter_new - allocate and initialize profiling data iterator
>> + * @info: profiling data set to be iterated
>> + *
>> + * Return file iterator on success, %NULL otherwise.
>> + */
>> +struct gcov_iterator *gcov_iter_new(struct gcov_info *info)
>> +{
>> +	struct gcov_iterator *iter;
>> +
>> +	iter = kzalloc(sizeof(struct gcov_iterator), GFP_KERNEL);
>> +	if (!iter)
>> +		goto err_free;
>> +
>> +	iter->info = info;
>> +	/* Dry-run to get the actual buffer size. */
>> +	iter->size = convert_to_gcda(NULL, info);
>> +	iter->buffer = vmalloc(iter->size);
>> +	if (!iter->buffer)
>> +		goto err_free;
>> +
>> +	convert_to_gcda(iter->buffer, info);
>> +
>> +	return iter;
>> +
>> +err_free:
>> +	kfree(iter);
>> +	return NULL;
>> +}
>> +
>> +/**
>> + * gcov_iter_free - release memory for iterator
>> + * @iter: file iterator to free
>> + */
>> +void gcov_iter_free(struct gcov_iterator *iter)
>> +{
>> +	vfree(iter->buffer);
>> +	kfree(iter);
>> +}
>> +
>> +/**
>> + * gcov_iter_get_info - return profiling data set for given file iterator
>> + * @iter: file iterator
>> + */
>> +struct gcov_info *gcov_iter_get_info(struct gcov_iterator *iter)
>> +{
>> +	return iter->info;
>> +}
>> +
>> +/**
>> + * gcov_iter_start - reset file iterator to starting position
>> + * @iter: file iterator
>> + */
>> +void gcov_iter_start(struct gcov_iterator *iter)
>> +{
>> +	iter->pos = 0;
>> +}
>> +
>> +/**
>> + * gcov_iter_next - advance file iterator to next logical record
>> + * @iter: file iterator
>> + *
>> + * Return zero if new position is valid, non-zero if iterator has reached end.
>> + */
>> +int gcov_iter_next(struct gcov_iterator *iter)
>> +{
>> +	if (iter->pos < iter->size)
>> +		iter->pos += ITER_STRIDE;
>> +	if (iter->pos >= iter->size)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * gcov_iter_write - write data for current pos to seq_file
>> + * @iter: file iterator
>> + * @seq: seq_file handle
>> + *
>> + * Return zero on success, non-zero otherwise.
>> + */
>> +int gcov_iter_write(struct gcov_iterator *iter, struct seq_file *seq)
>> +{
>> +	size_t len;
>> +
>> +	if (iter->pos >= iter->size)
>> +		return -EINVAL;
>> +
>> +	len = ITER_STRIDE;
>> +	if (iter->pos + len > iter->size)
>> +		len = iter->size - iter->pos;
>> +
>> +	seq_write(seq, iter->buffer + iter->pos, len);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * gcov_info_get_filename - return name of the associated gcov data file
>> + * @info: profiling data set
>> + */
>> +const char *gcov_info_get_filename(struct gcov_info *info)
>> +{
>> +	return info->filename;
>> +}
>>
>> -- 
>> Peter Oberparleiter
>> Linux on System z Development - IBM Germany


-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

