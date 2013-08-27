Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3H0QMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:12:13 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62422 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3H0QML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:12:11 -0400
Message-ID: <521CCFD8.90201@gmail.com>
Date: Tue, 27 Aug 2013 10:12:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fwd: perf: callchain feature on ARM - question about libunwind
 API
References: <CAFrcx1n5eA4zz+nUhraE_fi_Usc=PCZTC=RCT=S285K4=jqHSg@mail.gmail.com> <CAFrcx1nr4-qyzC=zFRdnMavHy5p_r9Ng+zSVwNPk6snYtBm6gw@mail.gmail.com>
In-Reply-To: <CAFrcx1nr4-qyzC=zFRdnMavHy5p_r9Ng+zSVwNPk6snYtBm6gw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Jiri who added the feature to perf]

On 8/27/13 5:58 AM, Jean Pihet wrote:
> Hi!
>
> I am looking for info and help on the libunwind API.
>
> What I am trying to achieve is to allow the callchain feature on perf
> for ARM (v7 to start with, then ARMv8), from the DWARF info found in
> the .debug_frame section.
>
>  From the source code in tools/perf I have added the call to
> dwarf_find_debug_frame to load and parse the debug info from
> .debug_frame. This works correctly, all IP ranges are found from the
> debug code (test program and libraries). Then at some point I get an
> assertion: 'perf: dwarf/Gparser.c:459: fetch_proc_info: Assertion
> `c->pi.unwind_info' failed.' At that point c->pi is NULL. Cf. below
> for more info.
>
> It looks like I am not using the libunwind API as it should, so that
> the perf code apparently builds a list of IP ranges to resolve but
> cannot use it later on to gather statistics on the runtime info.
>
> Any idea on how to progress? I am also looking at the *_proc_info API
> of libunwind.
>
> Here is the patch I am using below.
>
> Cheers,
> Jean
>
> ---
> Debug log:
>
> perf report --sort symbol --call-graph --stdio
>
> _Uarm_step: calling dwarf_step(ip=0x8464, c->dwarf@0xbee150f8,
> c->dwarf.pi@0xb2bc0008)
> unwind: find_proc_info dso /home/linaro/perf-libunwind/
> test_app/stress_bt
> read_unwind_spec_debug_frame: .debug_frame offset=9304
> opened file '/home/linaro/perf-libunwind/test_app/stress_bt'. Section
> header at offset 18152
> read 3160 bytes of .debug_frame from offset 9304
> ...
> _ULarm_step: calling dwarf_step(ip=0xb6e6e764, c->dwarf@0xbee07508,
> c->dwarf.pi@0xb6e955c0)
> _ULarm_find_proc_info: looking for IP=0xb6e6e763
> opened file '/usr/lib/arm-linux-gnueabihf/libunwind.so.8'. Section
> header at offset 513260
> read 17072 bytes of .debug_frame from offset 451836
> _ULarm_dwarf_search_unwind_table: looking for IP=0xb6e6e763
> _ULarm_find_proc_info returns 0
> ...
> perf: dwarf/Gparser.c:459: fetch_proc_info: Assertion
> `c->pi.unwind_info' failed.
>
>
> ---
> Patch to the kernel source:
>
> diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
> index 958723b..dd97688 100644
> --- a/tools/perf/util/unwind.c
> +++ b/tools/perf/util/unwind.c
> @@ -39,6 +39,14 @@ UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
>
>   #define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
>
> +extern int
> +UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
> +                unw_word_t ip, unw_word_t segbase,
> +                const char* obj_name, unw_word_t start,
> +                unw_word_t end);
> +
> +#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
> +
>   #define DW_EH_PE_FORMAT_MASK   0x0f    /* format of the encoded value */
>   #define DW_EH_PE_APPL_MASK 0x70    /* how the value is to be applied */
>
> @@ -245,8 +253,9 @@ static int unwind_spec_ehframe(struct dso *dso,
> struct      machine *machine,
>      return 0;
>   }
>
> -static int read_unwind_spec(struct dso *dso, struct machine *machine,
> -               u64 *table_data, u64 *segbase, u64 *fde_count)
> +static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
> +                    u64 *table_data, u64 *segbase,
> +                    u64 *fde_count)
>   {
>      int ret = -EINVAL, fd;
>      u64 offset;
> @@ -255,18 +264,40 @@ static int read_unwind_spec(struct dso *dso,
> struct       machine *machine,
>      if (fd < 0)
>          return -EINVAL;
>
> +   /* Check the .eh_frame section for unwinding info */
>      offset = elf_section_offset(fd, ".eh_frame_hdr");
>      close(fd);
>
> -   if (offset)
> +   if (offset) {
> +       fprintf(stderr, "%s: .eh_frame offset=%llu\n", __func__, offset);
>          ret = unwind_spec_ehframe(dso, machine, offset,
>                        table_data, segbase,
>                        fde_count);
> +   }
>
> -   /* TODO .debug_frame check if eh_frame_hdr fails */
>      return ret;
>   }
>
> +static int read_unwind_spec_debug_frame(struct dso *dso,
> +                   struct machine *machine,
> +                   u64 *segbase)
> +{
> +   int fd = dso__data_fd(dso, machine);
> +   if (fd < 0)
> +       return -EINVAL;
> +
> +   /* Check the .debug_frame section for unwinding info */
> +   *segbase = elf_section_offset(fd, ".debug_frame");
> +   close(fd);
> +
> +   fprintf(stderr, "%s: .debug_frame offset=%llu\n", __func__, *segbase);
> +
> +   if (!segbase)
> +       return -EINVAL;
> +
> +   return 0;
> +}
> +
>   static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
>   {
>      struct addr_location al;
> @@ -289,22 +320,32 @@ find_proc_info(unw_addr_space_t as, unw_word_t
> ip,        unw_proc_info_t *pi,
>      if (!map || !map->dso)
>          return -EINVAL;
>
> -   pr_debug("unwind: find_proc_info dso %s\n", map->dso->name);
> +   fprintf(stderr, "unwind: find_proc_info dso %s\n", map->dso->name);
> +
> +   /* Check the .eh_frame section for unwinding info */
> +   if (!read_unwind_spec_eh_frame(map->dso, ui->machine,
> +                      &table_data, &segbase, &fde_count)) {
> +       memset(&di, 0, sizeof(di));
> +       di.format   = UNW_INFO_FORMAT_REMOTE_TABLE;
> +       di.start_ip = map->start;
> +       di.end_ip   = map->end;
> +       di.u.rti.segbase    = map->start + segbase;
> +       di.u.rti.table_data = map->start + table_data;
> +       di.u.rti.table_len  = fde_count * sizeof(struct table_entry)
> +                 / sizeof(unw_word_t);
> +       return dwarf_search_unwind_table(as, ip, &di, pi,
> +                        need_unwind_info, arg);
> +   }
>
> -   if (read_unwind_spec(map->dso, ui->machine,
> -                &table_data, &segbase, &fde_count))
> -       return -EINVAL;
> +   /* Check the .debug_frame section for unwinding info */
> +   if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
> +       memset(&di, 0, sizeof(di));
> +       if (dwarf_find_debug_frame(0, &di, ip, segbase, map->dso->name,
> +                      map->start, map->end))
> +           return 0;
> +   }
>
> -   memset(&di, 0, sizeof(di));
> -   di.format   = UNW_INFO_FORMAT_REMOTE_TABLE;
> -   di.start_ip = map->start;
> -   di.end_ip   = map->end;
> -   di.u.rti.segbase    = map->start + segbase;
> -   di.u.rti.table_data = map->start + table_data;
> -   di.u.rti.table_len  = fde_count * sizeof(struct table_entry)
> -                 / sizeof(unw_word_t);
> -   return dwarf_search_unwind_table(as, ip, &di, pi,
> -                    need_unwind_info, arg);
> +   return -EINVAL;
>   }
>
>   static int access_fpreg(unw_addr_space_t __maybe_unused as,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

