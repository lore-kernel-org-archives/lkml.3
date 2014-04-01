Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaDAH3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:29:01 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:51890 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaDAH27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:28:59 -0400
Message-ID: <533A6AB3.5000305@hitachi.com>
Date: Tue, 01 Apr 2014 16:28:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 19/28] ktap: add userspace/symbol.[c|h]
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com> <1396014469-5937-20-git-send-email-jovi.zhangwei@gmail.com>
In-Reply-To: <1396014469-5937-20-git-send-email-jovi.zhangwei@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/28 22:47), Jovi Zhangwei wrote:
> This file is use for uprobe(include SDT) symbol lookup,
> for example:
> 
> trace probe:/lib64/libc.so.6:malloc {
> 	print("malloc entry:", execname)
> }
> 
> trace sdt:/lib64/libc.so.6:* {
>         print(execname, argstr)
> }
> 
> It need libelf library support.

Hmm, I think I should support this in perf-probe too...

Thank you,

> 
> Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
> ---
>  tools/ktap/userspace/kp_symbol.c | 360 +++++++++++++++++++++++++++++++++++++++
>  tools/ktap/userspace/kp_symbol.h |  50 ++++++
>  2 files changed, 410 insertions(+)
>  create mode 100644 tools/ktap/userspace/kp_symbol.c
>  create mode 100644 tools/ktap/userspace/kp_symbol.h
> 
> diff --git a/tools/ktap/userspace/kp_symbol.c b/tools/ktap/userspace/kp_symbol.c
> new file mode 100644
> index 0000000..59f8b5e
> --- /dev/null
> +++ b/tools/ktap/userspace/kp_symbol.c
> @@ -0,0 +1,360 @@
> +/*
> + * symbol.c
> + *
> + * This file is part of ktap by Jovi Zhangwei.
> + *
> + * Copyright (C) 2013 Azat Khuzhin <a3at.mail@gmail.com>.
> + *
> + * ktap is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * ktap is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <string.h>
> +#include <linux/limits.h>
> +
> +#include <libelf.h>
> +
> +#include "../include/ktap_types.h"
> +#include "kp_symbol.h"
> +
> +const char *dbg_link_name = ".gnu_debuglink";
> +const char *dbg_bin_dir = "/usr/lib/debug";
> +
> +static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
> +				    GElf_Shdr *shp, const char *name)
> +{
> +	Elf_Scn *scn = NULL;
> +
> +	/* Elf is corrupted/truncated, avoid calling elf_strptr. */
> +	if (!elf_rawdata(elf_getscn(elf, ep->e_shstrndx), NULL))
> +		return NULL;
> +
> +	while ((scn = elf_nextscn(elf, scn)) != NULL) {
> +		char *str;
> +
> +		gelf_getshdr(scn, shp);
> +		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
> +		if (!strcmp(name, str))
> +			break;
> +	}
> +
> +	return scn;
> +}
> +
> +/**
> + * @return v_addr of "LOAD" program header, that have zero offset.
> + */
> +static int find_load_address(Elf *elf, vaddr_t *load_address)
> +{
> +	GElf_Phdr phdr;
> +	size_t i, phdrnum;
> +
> +	if (elf_getphdrnum(elf, &phdrnum))
> +		return -1;
> +
> +	for (i = 0; i < phdrnum; i++) {
> +		if (gelf_getphdr(elf, i, &phdr) == NULL)
> +			return -1;
> +
> +		if (phdr.p_type != PT_LOAD || phdr.p_offset != 0)
> +			continue;
> +
> +		*load_address = phdr.p_vaddr;
> +		return 0;
> +	}
> +
> +	/* cannot found load address */
> +	return -1;
> +}
> +
> +static size_t elf_symbols(GElf_Shdr shdr)
> +{
> +	return shdr.sh_size / shdr.sh_entsize;
> +}
> +
> +static int dso_symbols(Elf *elf, symbol_actor actor, void *arg)
> +{
> +	Elf_Data *elf_data = NULL;
> +	Elf_Scn *scn = NULL;
> +	GElf_Sym sym;
> +	GElf_Shdr shdr;
> +	int symbols_count = 0;
> +	vaddr_t load_address;
> +
> +	if (find_load_address(elf, &load_address))
> +		return -1;
> +
> +	while ((scn = elf_nextscn(elf, scn))) {
> +		int i;
> +
> +		gelf_getshdr(scn, &shdr);
> +
> +		if (shdr.sh_type != SHT_SYMTAB)
> +			continue;
> +
> +		elf_data = elf_getdata(scn, elf_data);
> +
> +		for (i = 0; i < elf_symbols(shdr); i++) {
> +			char *name;
> +			vaddr_t addr;
> +			int ret;
> +
> +			gelf_getsym(elf_data, i, &sym);
> +
> +			if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
> +				continue;
> +
> +			name = elf_strptr(elf, shdr.sh_link, sym.st_name);
> +			addr = sym.st_value - load_address;
> +
> +			ret = actor(name, addr, arg);
> +			if (ret)
> +				return ret;
> +
> +			++symbols_count;
> +		}
> +	}
> +
> +	return symbols_count;
> +}
> +
> +#define SDT_NOTE_TYPE 3
> +#define SDT_NOTE_COUNT 3
> +#define SDT_NOTE_SCN ".note.stapsdt"
> +#define SDT_NOTE_NAME "stapsdt"
> +
> +static vaddr_t sdt_note_addr(Elf *elf, const char *data, size_t len, int type)
> +{
> +	vaddr_t vaddr;
> +
> +	/*
> +	 * Three addresses need to be obtained :
> +	 * Marker location, address of base section and semaphore location
> +	 */
> +	union {
> +		Elf64_Addr a64[3];
> +		Elf32_Addr a32[3];
> +	} buf;
> +
> +	/*
> +	 * dst and src are required for translation from file to memory
> +	 * representation
> +	 */
> +	Elf_Data dst = {
> +		.d_buf = &buf, .d_type = ELF_T_ADDR, .d_version = EV_CURRENT,
> +		.d_size = gelf_fsize(elf, ELF_T_ADDR, SDT_NOTE_COUNT, EV_CURRENT),
> +		.d_off = 0, .d_align = 0
> +	};
> +
> +	Elf_Data src = {
> +		.d_buf = (void *) data, .d_type = ELF_T_ADDR,
> +		.d_version = EV_CURRENT, .d_size = dst.d_size, .d_off = 0,
> +		.d_align = 0
> +	};
> +
> +	/* Check the type of each of the notes */
> +	if (type != SDT_NOTE_TYPE)
> +		return 0;
> +
> +	if (len < dst.d_size + SDT_NOTE_COUNT)
> +		return 0;
> +
> +	/* Translation from file representation to memory representation */
> +	if (gelf_xlatetom(elf, &dst, &src,
> +			  elf_getident(elf, NULL)[EI_DATA]) == NULL)
> +		return 0; /* TODO */
> +
> +	memcpy(&vaddr, &buf, sizeof(vaddr));
> +
> +	return vaddr;
> +}
> +
> +static const char *sdt_note_name(Elf *elf, GElf_Nhdr *nhdr, const char *data)
> +{
> +	const char *provider = data + gelf_fsize(elf,
> +		ELF_T_ADDR, SDT_NOTE_COUNT, EV_CURRENT);
> +	const char *name = (const char *)memchr(provider, '\0',
> +		data + nhdr->n_descsz - provider);
> +
> +	if (name++ == NULL)
> +		return NULL;
> +
> +	return name;
> +}
> +
> +static const char *sdt_note_data(const Elf_Data *data, size_t off)
> +{
> +	return ((data->d_buf) + off);
> +}
> +
> +static int dso_sdt_notes(Elf *elf, symbol_actor actor, void *arg)
> +{
> +	GElf_Ehdr ehdr;
> +	Elf_Scn *scn = NULL;
> +	Elf_Data *data;
> +	GElf_Shdr shdr;
> +	size_t shstrndx;
> +	size_t next;
> +	GElf_Nhdr nhdr;
> +	size_t name_off, desc_off, offset;
> +	vaddr_t vaddr = 0;
> +	int symbols_count = 0;
> +
> +	if (gelf_getehdr(elf, &ehdr) == NULL)
> +		return 0;
> +	if (elf_getshdrstrndx(elf, &shstrndx) != 0)
> +		return 0;
> +
> +	/*
> +	 * Look for section type = SHT_NOTE, flags = no SHF_ALLOC
> +	 * and name = .note.stapsdt
> +	 */
> +	scn = elf_section_by_name(elf, &ehdr, &shdr, SDT_NOTE_SCN);
> +	if (!scn)
> +		return 0;
> +	if (!(shdr.sh_type == SHT_NOTE) || (shdr.sh_flags & SHF_ALLOC))
> +		return 0;
> +
> +	data = elf_getdata(scn, NULL);
> +
> +	for (offset = 0;
> +		(next = gelf_getnote(data, offset, &nhdr, &name_off, &desc_off)) > 0;
> +		offset = next) {
> +		const char *name;
> +		int ret;
> +
> +		if (nhdr.n_namesz != sizeof(SDT_NOTE_NAME) ||
> +		    memcmp(data->d_buf + name_off, SDT_NOTE_NAME,
> +			    sizeof(SDT_NOTE_NAME)))
> +			continue;
> +
> +		name = sdt_note_name(elf, &nhdr, sdt_note_data(data, desc_off));
> +		if (!name)
> +			continue;
> +
> +		vaddr = sdt_note_addr(elf, sdt_note_data(data, desc_off),
> +					nhdr.n_descsz, nhdr.n_type);
> +		if (!vaddr)
> +			continue;
> +
> +		ret = actor(name, vaddr, arg);
> +		if (ret)
> +			return ret;
> +
> +		++symbols_count;
> +	}
> +
> +	return symbols_count;
> +}
> +
> +int dso_follow_debuglink(Elf *elf,
> +			 const char *orig_exec,
> +			 int type,
> +			 symbol_actor actor,
> +			 void *arg)
> +{
> +	GElf_Ehdr ehdr;
> +	size_t shstrndx, orig_exec_dir_len;
> +	GElf_Shdr shdr;
> +	Elf_Scn *dbg_link_scn;
> +	Elf_Data *dbg_link_scn_data;
> +	char *dbg_link, *dbg_bin, *last_slash;
> +	int symbols_count;
> +
> +	/* First try to find the .gnu_debuglink section in the binary. */
> +	if (gelf_getehdr(elf, &ehdr) == NULL)
> +		return 0;
> +	if (elf_getshdrstrndx(elf, &shstrndx) != 0)
> +		return 0;
> +
> +	dbg_link_scn = elf_section_by_name(elf, &ehdr, &shdr, dbg_link_name);
> +	if (dbg_link_scn == NULL)
> +		return 0;
> +
> +	/* Debug link section found, read of the content (only get the first
> +	   string, no checksum checking atm). This is debug binary file name. */
> +	dbg_link_scn_data = elf_getdata(dbg_link_scn, NULL);
> +	if (dbg_link_scn_data == NULL ||
> +	    dbg_link_scn_data->d_size <= 0 ||
> +	    dbg_link_scn_data->d_buf == NULL)
> +		return 0;
> +
> +	/* Now compose debug executable name */
> +	dbg_link = (char *)(dbg_link_scn_data->d_buf);
> +	dbg_bin = malloc(strlen(dbg_bin_dir) + 1 +
> +			 strlen(orig_exec) + 1 +
> +			 strlen(dbg_link) + 1);
> +	if (!dbg_bin)
> +		return 0;
> +
> +	orig_exec_dir_len = PATH_MAX;
> +	last_slash = strrchr(orig_exec, '/');
> +	if (last_slash != NULL)
> +		orig_exec_dir_len = last_slash - orig_exec;
> +
> +	sprintf(dbg_bin, "%s/%.*s/%s",
> +		dbg_bin_dir, (int)orig_exec_dir_len, orig_exec, dbg_link);
> +
> +	/* Retry symbol seach with the debug binary */
> +	symbols_count = parse_dso_symbols(dbg_bin, type, actor, arg);
> +
> +	free(dbg_bin);
> +
> +	return symbols_count;
> +}
> +
> +int parse_dso_symbols(const char *exec, int type, symbol_actor actor, void *arg)
> +{
> +	int symbols_count = 0;
> +	Elf *elf;
> +	int fd;
> +
> +	if (elf_version(EV_CURRENT) == EV_NONE)
> +		return -1;
> +
> +	fd = open(exec, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +
> +	elf = elf_begin(fd, ELF_C_READ, NULL);
> +	if (elf) {
> +		switch (type) {
> +		case FIND_SYMBOL:
> +			symbols_count = dso_symbols(elf, actor, arg);
> +			if (symbols_count != 0)
> +				break;
> +			/* If no symbols found, try in the debuglink binary. */
> +			symbols_count = dso_follow_debuglink(elf,
> +							     exec,
> +							     type,
> +							     actor,
> +							     arg);
> +			break;
> +		case FIND_STAPSDT_NOTE:
> +			symbols_count = dso_sdt_notes(elf, actor, arg);
> +			break;
> +		}
> +
> +		elf_end(elf);
> +	}
> +
> +	close(fd);
> +	return symbols_count;
> +}
> diff --git a/tools/ktap/userspace/kp_symbol.h b/tools/ktap/userspace/kp_symbol.h
> new file mode 100644
> index 0000000..650e785
> --- /dev/null
> +++ b/tools/ktap/userspace/kp_symbol.h
> @@ -0,0 +1,50 @@
> +/*
> + * symbol.h - extract symbols from DSO.
> + *
> + * This file is part of ktap by Jovi Zhangwei.
> + *
> + * Copyright (C) 2013 Azat Khuzhin <a3at.mail@gmail.com>.
> + *
> + * ktap is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * ktap is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +
> +#define FIND_SYMBOL 1
> +#define FIND_STAPSDT_NOTE 2
> +
> +#ifndef NO_LIBELF
> +
> +#include <gelf.h>
> +#include <sys/queue.h>
> +
> +typedef GElf_Addr vaddr_t;
> +typedef int (*symbol_actor)(const char *name, vaddr_t addr, void *arg);
> +
> +/**
> + * Parse all DSO symbols/sdt notes and all for every of them
> + * an actor.
> + *
> + * @exec - path to DSO
> + * @type - see FIND_*
> + * @symbol_actor - actor to call (callback)
> + * @arg - argument for @actor
> + *
> + * @return
> + * If there have errors, return negative value;
> + * No symbols found, return 0;
> + * Otherwise return number of dso symbols found
> + */
> +int
> +parse_dso_symbols(const char *exec, int type, symbol_actor actor, void *arg);
> +#endif
> 


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


