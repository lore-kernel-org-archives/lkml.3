Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab3IEQtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:49:15 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60407 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab3IEQtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:49:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130905163030.GF1100@krava.brq.redhat.com>
References: <1378317854-25965-1-git-send-email-jean.pihet@linaro.org>
	<1378317854-25965-4-git-send-email-jean.pihet@linaro.org>
	<20130905163030.GF1100@krava.brq.redhat.com>
Date: Thu, 5 Sep 2013 18:49:13 +0200
Message-ID: <CAFrcx1nYS1J5zZjAQMgXrrkz9C332-EJQgj=2vcoidSvLe_JeQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 5 September 2013 18:30, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Sep 04, 2013 at 08:04:14PM +0200, Jean Pihet wrote:
>> On ARM the debug info is not present in the .eh_frame sections but
>> instead in .debug_frame.
>> Use libunwind to load and parse the debug info.
>
> hum, cannot make final link:
>
> $ make LIBUNWIND_DIR=/opt/libunwind/
>     CHK -fstack-protector-all
>     CHK -Wstack-protector
>     CHK -Wvolatile-register-var
>     CHK -D_FORTIFY_SOURCE=2
>     CHK bionic
>     CHK libelf
>     CHK libdw
>     CHK -DLIBELF_MMAP
>     CHK -DLIBELF_MMAP
>     CHK libunwind
>     CHK libaudit
>
> ...
>
> make[1]: `liblk.a' is up to date.
>     SUBDIR /home/jolsa/linux-perf/tools/lib/traceevent/
>     LINK perf
> libperf.a(unwind.o): In function `find_proc_info':
> /home/jolsa/linux-perf/tools/perf/util/unwind.c:339: undefined reference to `_Ux86_64_dwarf_find_debug_frame'
> collect2: ld returned 1 exit status
> make: *** [perf] Error 1
>
>
> I'm using the latest code from git://git.sv.gnu.org/libunwind.git
>
> Looks like dwarf_find_debug_frame is not exported, although
> it looks like it is based on what I see in libunwind sources ;-)
>
> What did I miss?
Weird, I do not have the error on x86_64. I am investigating this and
will come back to you asap.

>
> Also few typo comments below..
>
> thanks,
> jirka
>
>>
>> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
>> ---
>>  tools/perf/util/unwind.c | 70 +++++++++++++++++++++++++++++++++++++-----------
>>  1 file changed, 54 insertions(+), 16 deletions(-)
>>
>> diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
>> index 958723b..5353b32 100644
>> --- a/tools/perf/util/unwind.c
>> +++ b/tools/perf/util/unwind.c
>> @@ -39,6 +39,14 @@ UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
>>
>>  #define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
>>
>> +extern int
>> +UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
>> +                                                              unw_word_t ip, unw_word_t segbase,
>> +                                                              const char *obj_name, unw_word_t start,
>> +                                                              unw_word_t end);
>> +
>> +#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
>> +
>>  #define DW_EH_PE_FORMAT_MASK 0x0f    /* format of the encoded value */
>>  #define DW_EH_PE_APPL_MASK   0x70    /* how the value is to be applied */
>>
>> @@ -245,8 +253,9 @@ static int unwind_spec_ehframe(struct dso *dso, struct machine *machine,
>>       return 0;
>>  }
>>
>> -static int read_unwind_spec(struct dso *dso, struct machine *machine,
>> -                         u64 *table_data, u64 *segbase, u64 *fde_count)
>> +static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
>> +                                  u64 *table_data, u64 *segbase,
>> +                                  u64 *fde_count)
>>  {
>>       int ret = -EINVAL, fd;
>>       u64 offset;
>> @@ -255,6 +264,7 @@ static int read_unwind_spec(struct dso *dso, struct machine *machine,
>>       if (fd < 0)
>>               return -EINVAL;
>>
>> +     /* Check the .eh_frame section for unwinding info */
>>       offset = elf_section_offset(fd, ".eh_frame_hdr");
>>       close(fd);
>>
>> @@ -263,10 +273,27 @@ static int read_unwind_spec(struct dso *dso, struct machine *machine,
>>                                         table_data, segbase,
>>                                         fde_count);
>>
>> -     /* TODO .debug_frame check if eh_frame_hdr fails */
>>       return ret;
>>  }
>>
>> +static int read_unwind_spec_debug_frame(struct dso *dso,
>> +                                                                             struct machine *machine, u64 *offset)
>> +{
>
> some strange formatting issue ^^^ ;-)
I am using 4-spaces tabs. scripts/checkpatch.pl reported it to me in
the form of too long lines.
Should I change the code to 8-spaces tabs?

Thx!
Jean

>
>
>> +     int fd = dso__data_fd(dso, machine);
>> +
>> +     if (fd < 0)
>> +             return -EINVAL;
>> +
>> +     /* Check the .debug_frame section for unwinding info */
>> +     *offset = elf_section_offset(fd, ".debug_frame");
>> +     close(fd);
>> +
>> +     if (*offset)
>> +             return 0;
>> +
>> +     return -EINVAL;
>> +}
>> +
>>  static struct map *find_map(unw_word_t ip, struct unwind_info *ui)
>>  {
>>       struct addr_location al;
>> @@ -291,20 +318,31 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
>>
>>       pr_debug("unwind: find_proc_info dso %s\n", map->dso->name);
>>
>> -     if (read_unwind_spec(map->dso, ui->machine,
>> -                          &table_data, &segbase, &fde_count))
>> -             return -EINVAL;
>> +     /* Check the .eh_frame section for unwinding info */
>> +     if (!read_unwind_spec_eh_frame(map->dso, ui->machine,
>> +                                                                &table_data, &segbase, &fde_count)) {
>
> ditto ^^^
>
>> +             memset(&di, 0, sizeof(di));
>> +             di.format   = UNW_INFO_FORMAT_REMOTE_TABLE;
>> +             di.start_ip = map->start;
>> +             di.end_ip   = map->end;
>> +             di.u.rti.segbase    = map->start + segbase;
>> +             di.u.rti.table_data = map->start + table_data;
>> +             di.u.rti.table_len  = fde_count * sizeof(struct table_entry)
>> +                                                       / sizeof(unw_word_t);
>> +         return dwarf_search_unwind_table(as, ip, &di, pi,
>> +                                                                              need_unwind_info, arg);
>
> ditto ^^^
>
>> +     }
>> +
>> +     /* Check the .debug_frame section for unwinding info */
>> +     if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
>> +             memset(&di, 0, sizeof(di));
>> +             dwarf_find_debug_frame(0, &di, ip, 0, map->dso->name,
>> +                                                        map->start, map->end);
>> +             return dwarf_search_unwind_table(as, ip, &di, pi,
>> +                                                                              need_unwind_info, arg);
>
> ditto ^^^
>
>> +     }
>>
>> -     memset(&di, 0, sizeof(di));
>> -     di.format   = UNW_INFO_FORMAT_REMOTE_TABLE;
>> -     di.start_ip = map->start;
>> -     di.end_ip   = map->end;
>> -     di.u.rti.segbase    = map->start + segbase;
>> -     di.u.rti.table_data = map->start + table_data;
>> -     di.u.rti.table_len  = fde_count * sizeof(struct table_entry)
>> -                           / sizeof(unw_word_t);
>> -     return dwarf_search_unwind_table(as, ip, &di, pi,
>> -                                      need_unwind_info, arg);
>> +     return -EINVAL;
>>  }
>>
>>  static int access_fpreg(unw_addr_space_t __maybe_unused as,
>> --
>> 1.7.11.7
>>
