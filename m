Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124Ab3IFKRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:17:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab3IFKRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:17:41 -0400
Date: Fri, 6 Sep 2013 12:17:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
Message-ID: <20130906101710.GA2749@krava.brq.redhat.com>
References: <1378317854-25965-1-git-send-email-jean.pihet@linaro.org>
 <1378317854-25965-4-git-send-email-jean.pihet@linaro.org>
 <20130905163030.GF1100@krava.brq.redhat.com>
 <CAFrcx1nYS1J5zZjAQMgXrrkz9C332-EJQgj=2vcoidSvLe_JeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1nYS1J5zZjAQMgXrrkz9C332-EJQgj=2vcoidSvLe_JeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 06:49:13PM +0200, Jean Pihet wrote:
> Hi Jiri,
> 
> On 5 September 2013 18:30, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Wed, Sep 04, 2013 at 08:04:14PM +0200, Jean Pihet wrote:
> >> On ARM the debug info is not present in the .eh_frame sections but
> >> instead in .debug_frame.
> >> Use libunwind to load and parse the debug info.
> >
> > hum, cannot make final link:
> >
> > $ make LIBUNWIND_DIR=/opt/libunwind/
> >     CHK -fstack-protector-all
> >     CHK -Wstack-protector
> >     CHK -Wvolatile-register-var
> >     CHK -D_FORTIFY_SOURCE=2
> >     CHK bionic
> >     CHK libelf
> >     CHK libdw
> >     CHK -DLIBELF_MMAP
> >     CHK -DLIBELF_MMAP
> >     CHK libunwind
> >     CHK libaudit
> >
> > ...
> >
> > make[1]: `liblk.a' is up to date.
> >     SUBDIR /home/jolsa/linux-perf/tools/lib/traceevent/
> >     LINK perf
> > libperf.a(unwind.o): In function `find_proc_info':
> > /home/jolsa/linux-perf/tools/perf/util/unwind.c:339: undefined reference to `_Ux86_64_dwarf_find_debug_frame'
> > collect2: ld returned 1 exit status
> > make: *** [perf] Error 1
> >
> >
> > I'm using the latest code from git://git.sv.gnu.org/libunwind.git
> >
> > Looks like dwarf_find_debug_frame is not exported, although
> > it looks like it is based on what I see in libunwind sources ;-)
> >
> > What did I miss?
> Weird, I do not have the error on x86_64. I am investigating this and
> will come back to you asap.
> 
> >
> > Also few typo comments below..
> >
> > thanks,
> > jirka
> >
> >>
> >> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> >> ---
> >>  tools/perf/util/unwind.c | 70 +++++++++++++++++++++++++++++++++++++-----------
> >>  1 file changed, 54 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
> >> index 958723b..5353b32 100644
> >> --- a/tools/perf/util/unwind.c
> >> +++ b/tools/perf/util/unwind.c
> >> @@ -39,6 +39,14 @@ UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
> >>
> >>  #define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
> >>
> >> +extern int
> >> +UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
> >> +                                                              unw_word_t ip, unw_word_t segbase,
> >> +                                                              const char *obj_name, unw_word_t start,
> >> +                                                              unw_word_t end);
> >> +
> >> +#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
> >> +
> >>  #define DW_EH_PE_FORMAT_MASK 0x0f    /* format of the encoded value */
> >>  #define DW_EH_PE_APPL_MASK   0x70    /* how the value is to be applied */
> >>
> >> @@ -245,8 +253,9 @@ static int unwind_spec_ehframe(struct dso *dso, struct machine *machine,
> >>       return 0;
> >>  }
> >>
> >> -static int read_unwind_spec(struct dso *dso, struct machine *machine,
> >> -                         u64 *table_data, u64 *segbase, u64 *fde_count)
> >> +static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
> >> +                                  u64 *table_data, u64 *segbase,
> >> +                                  u64 *fde_count)
> >>  {
> >>       int ret = -EINVAL, fd;
> >>       u64 offset;
> >> @@ -255,6 +264,7 @@ static int read_unwind_spec(struct dso *dso, struct machine *machine,
> >>       if (fd < 0)
> >>               return -EINVAL;
> >>
> >> +     /* Check the .eh_frame section for unwinding info */
> >>       offset = elf_section_offset(fd, ".eh_frame_hdr");
> >>       close(fd);
> >>
> >> @@ -263,10 +273,27 @@ static int read_unwind_spec(struct dso *dso, struct machine *machine,
> >>                                         table_data, segbase,
> >>                                         fde_count);
> >>
> >> -     /* TODO .debug_frame check if eh_frame_hdr fails */
> >>       return ret;
> >>  }
> >>
> >> +static int read_unwind_spec_debug_frame(struct dso *dso,
> >> +                                                                             struct machine *machine, u64 *offset)
> >> +{
> >
> > some strange formatting issue ^^^ ;-)
> I am using 4-spaces tabs. scripts/checkpatch.pl reported it to me in
> the form of too long lines.
> Should I change the code to 8-spaces tabs?
> 

right, if I set tabs to 4 space then it's ok
so I guess 8 is globally agreed ;-)

jirka
