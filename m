Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaHUHA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 03:00:29 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55608 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbaHUHA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 03:00:26 -0400
Date: Thu, 21 Aug 2014 09:00:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] x86, acpi: Handle xapic/x2apic entries in MADT at
 same time
Message-ID: <20140821070021.GA25888@gmail.com>
References: <1358804360-29639-1-git-send-email-yinghai@kernel.org>
 <CAE9FiQX0bUdWz6bmqLKDHpY5mvjEYdobseroCRnu0-Ju0qmsPw@mail.gmail.com>
 <1f7d783e-5b26-495d-83d5-5d522eb3941e@email.android.com>
 <CAE9FiQWPiVb_hySAADQypuZtcTN+iEQb4hoO=-+iurdsmKqKrg@mail.gmail.com>
 <CAE9FiQUcq05K1mR5E7K-MT3+Z4xxckxO+o9RJ6QDwiGG1T_3aQ@mail.gmail.com>
 <CAE9FiQVHcPH3aOU3uD=PsWay1w+csSDzZk62tpMXVgsFVMW1wg@mail.gmail.com>
 <CAE9FiQVGZf_cRMK0spp9=YhG8SsrK+FY6fi00pCxZcEL1Ne-kg@mail.gmail.com>
 <CAE9FiQW6q860P4+qQWTwt0k0vjOJ-S6FdyZHv06=0qv1Z97C=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW6q860P4+qQWTwt0k0vjOJ-S6FdyZHv06=0qv1Z97C=g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(lkml Cc:-ed, in case someone wants to help out.)

The changelog quality and organization of your submitted 
patches is still poor, they are hard to read and review. This 
is a repeat complaint against your patches, yet not much has 
happened over the last few years. Please improve them before 
resending your patches.

As a positive example, here's a couple of x86 architecture 
commits with good changelogs:

95d76acc7518 ("x86, irq: Count legacy IRQs by legacy_pic->nr_legacy_irqs instead of NR_IRQS_LEGACY")
6b9fb7082409 ("x86, ACPI, irq: Consolidate algorithm of mapping (ioapic, pin) to IRQ number")
2e0ad0e2c135 ("x86, ACPI, irq: Fix possible error in GSI to IRQ mapping for legacy IRQ")
44a69f619562 ("acpi, apei, ghes: Make NMI error notification to be GHES architecture extension")

Please match or exceed the changelog quality of these commits.

Thanks,

	Ingo

* Yinghai Lu <yinghai@kernel.org> wrote:

> Ping!
> 
> On Tue, Jul 29, 2014 at 1:22 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > new address for Rafael.
> >
> > On Tue, Jul 29, 2014 at 1:21 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> On Mon, Oct 14, 2013 at 1:13 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>> ping!
> >>>
> >>> On Fri, Sep 27, 2013 at 8:40 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>>> On Thu, Aug 22, 2013 at 10:41 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >>>>> Yinghai Lu <yinghai@kernel.org> wrote:
> >>>>>>On Mon, Jan 21, 2013 at 1:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>>>>>> One system have mixing xapic and x2apic entries in MADT and SRAT.
> >>>>>>> BIOS guys insist that ACPI 4.0 SPEC said so, if apic id < 255, even
> >>>>>>> the cpus are with x2apic mode pre-enabled, still need to use xapic
> >>>>>>entries
> >>>>>>> instead of x2apic entries.
> >>>>>>>
> >>>>>>> on 8 socket system with x2apic pre-enabled, will get out of order
> >>>>>>sequence:
> >>>>>>> CPU0: socket0, core0, thread0.
> >>>>>>> CPU1 - CPU 40: socket 4 - socket 7, thread 0
> >>>>>>> CPU41 - CPU 80: socket 4 - socket 7, thread 1
> >>>>>>> CPU81 - CPU 119: socket 0 - socket 3, thread 0
> >>>>>>> CPU120 - CPU 159: socket 0 - socket 3, thread 1
> >>>>>>>
> >>>>>>> so max_cpus=80 will not get all thread0 now.
> >>>>>>>
> >>>>>>> Need to handle every entry in MADT at same time with xapic and
> >>>>>>x2apic.
> >>>>>>> so we can honor sequence in MADT.
> >>>>>>>
> >>>>>>> We can use max_cpus= command line to use thread0 in every core,
> >>>>>>> because recent MADT always have all thread0 at first.
> >>>>>>> Also it could make the cpu to node mapping more sane.
> >>>>>>>
> >>>>>>> after patch will get
> >>>>>>> CPU0 - CPU 79: socket 0 - socket 7, thread 0
> >>>>>>> CPU80 - CPU 159: socket 0 - socket 7, thread 1
> >>>>>>>
> >>>>>>> -v2: update some comments, and change to pass array pointer.
> >>>>>>>
> >>>>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>>>>>> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> >>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>>>>>> Cc: Ingo Molnar <mingo@redhat.com>
> >>>>>>> Cc: "H. Peter Anvin" <hpa@zytor.com>
> >>>>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>>>>>> Cc: linux-kernel@vger.kernel.org
> >>>>>>>
> >>>>>>> ---
> >>>>>>>  arch/x86/kernel/acpi/boot.c |   30 ++++++++++++-----
> >>>>>>>  drivers/acpi/numa.c         |   16 +++++++--
> >>>>>>>  drivers/acpi/tables.c       |   75
> >>>>>>++++++++++++++++++++++++++++++++------------
> >>>>>>>  include/linux/acpi.h        |    9 +++++
> >>>>>>>  4 files changed, 97 insertions(+), 33 deletions(-)
> >>>>>>>
> >>>>>>> Index: linux-2.6/drivers/acpi/tables.c
> >>>>>>> ===================================================================
> >>>>>>> --- linux-2.6.orig/drivers/acpi/tables.c
> >>>>>>> +++ linux-2.6/drivers/acpi/tables.c
> >>>>>>> @@ -199,12 +199,10 @@ void acpi_table_print_madt_entry(struct
> >>>>>>>         }
> >>>>>>>  }
> >>>>>>>
> >>>>>>> -
> >>>>>>>  int __init
> >>>>>>> -acpi_table_parse_entries(char *id,
> >>>>>>> +acpi_table_parse_entries_array(char *id,
> >>>>>>>                              unsigned long table_size,
> >>>>>>> -                            int entry_id,
> >>>>>>> -                            acpi_tbl_entry_handler handler,
> >>>>>>> +                            struct acpi_subtable_proc *proc, int
> >>>>>>proc_num,
> >>>>>>>                              unsigned int max_entries)
> >>>>>>>  {
> >>>>>>>         struct acpi_table_header *table_header = NULL;
> >>>>>>> @@ -212,12 +210,12 @@ acpi_table_parse_entries(char *id,
> >>>>>>>         unsigned int count = 0;
> >>>>>>>         unsigned long table_end;
> >>>>>>>         acpi_size tbl_size;
> >>>>>>> +       int i;
> >>>>>>>
> >>>>>>> -       if (acpi_disabled)
> >>>>>>> +       if (acpi_disabled) {
> >>>>>>> +               proc[0].count = -ENODEV;
> >>>>>>>                 return -ENODEV;
> >>>>>>> -
> >>>>>>> -       if (!handler)
> >>>>>>> -               return -EINVAL;
> >>>>>>> +       }
> >>>>>>>
> >>>>>>>         if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
> >>>>>>>                 acpi_get_table_with_size(id, acpi_apic_instance,
> >>>>>>&table_header, &tbl_size);
> >>>>>>> @@ -226,6 +224,7 @@ acpi_table_parse_entries(char *id,
> >>>>>>>
> >>>>>>>         if (!table_header) {
> >>>>>>>                 printk(KERN_WARNING PREFIX "%4.4s not present\n",
> >>>>>>id);
> >>>>>>> +               proc[0].count = -ENODEV;
> >>>>>>>                 return -ENODEV;
> >>>>>>>         }
> >>>>>>>
> >>>>>>> @@ -238,33 +237,69 @@ acpi_table_parse_entries(char *id,
> >>>>>>>
> >>>>>>>         while (((unsigned long)entry) + sizeof(struct
> >>>>>>acpi_subtable_header) <
> >>>>>>>                table_end) {
> >>>>>>> -               if (entry->type == entry_id
> >>>>>>> -                   && (!max_entries || count++ < max_entries))
> >>>>>>> -                       if (handler(entry, table_end))
> >>>>>>> -                               goto err;
> >>>>>>> +               for (i = 0; i < proc_num; i++) {
> >>>>>>> +                       if (entry->type != proc[i].id)
> >>>>>>> +                               continue;
> >>>>>>> +                       if (max_entries && count++ >= max_entries)
> >>>>>>> +                               continue;
> >>>>>>> +                       if (proc[i].handler(entry, table_end)) {
> >>>>>>> +                               early_acpi_os_unmap_memory((char
> >>>>>>*)table_header,
> >>>>>>> +
> >>>>>>tbl_size);
> >>>>>>> +                               proc[i].count = -EINVAL;
> >>>>>>> +                               return -EINVAL;
> >>>>>>> +                       }
> >>>>>>> +                       proc[i].count++;
> >>>>>>> +                       break;
> >>>>>>> +               }
> >>>>>>>
> >>>>>>>                 /*
> >>>>>>>                  * If entry->length is 0, break from this loop to
> >>>>>>avoid
> >>>>>>>                  * infinite loop.
> >>>>>>>                  */
> >>>>>>>                 if (entry->length == 0) {
> >>>>>>> -                       pr_err(PREFIX "[%4.4s:0x%02x] Invalid zero
> >>>>>>length\n", id, entry_id);
> >>>>>>> -                       goto err;
> >>>>>>> -               }
> >>>>>>> +                       pr_err(PREFIX "[%4.4s:0x%02x ", id,
> >>>>>>proc[0].id);
> >>>>>>> +                       for (i = 1; i < proc_num; i++)
> >>>>>>> +                               printk(KERN_CONT " 0x%02x",
> >>>>>>proc[i].id);
> >>>>>>> +                       pr_err(KERN_CONT "] Invalid zero length\n");
> >>>>>>> +                       early_acpi_os_unmap_memory((char
> >>>>>>*)table_header,
> >>>>>>> +                                                        tbl_size);
> >>>>>>> +                       proc[0].count = -EINVAL;
> >>>>>>> +                       return -EINVAL;
> >>>>>>> +               }
> >>>>>>>
> >>>>>>>                 entry = (struct acpi_subtable_header *)
> >>>>>>>                     ((unsigned long)entry + entry->length);
> >>>>>>>         }
> >>>>>>>         if (max_entries && count > max_entries) {
> >>>>>>> -               printk(KERN_WARNING PREFIX "[%4.4s:0x%02x] ignored %i
> >>>>>>entries of "
> >>>>>>> -                      "%i found\n", id, entry_id, count -
> >>>>>>max_entries, count);
> >>>>>>> +               printk(KERN_WARNING PREFIX "[%4.4s:0x%02x ", id,
> >>>>>>proc[0].id);
> >>>>>>> +               for (i = 1; i < proc_num; i++)
> >>>>>>> +                       printk(KERN_CONT " 0x%02x", proc[i].id);
> >>>>>>> +               printk(KERN_CONT "] ignored %i entries of %i
> >>>>>>found\n",
> >>>>>>> +                      count-max_entries, count);
> >>>>>>>         }
> >>>>>>>
> >>>>>>>         early_acpi_os_unmap_memory((char *)table_header, tbl_size);
> >>>>>>>         return count;
> >>>>>>> -err:
> >>>>>>> -       early_acpi_os_unmap_memory((char *)table_header, tbl_size);
> >>>>>>> -       return -EINVAL;
> >>>>>>> +}
> >>>>>>> +
> >>>>>>> +int __init
> >>>>>>> +acpi_table_parse_entries(char *id,
> >>>>>>> +                            unsigned long table_size,
> >>>>>>> +                            int entry_id,
> >>>>>>> +                            acpi_tbl_entry_handler handler,
> >>>>>>> +                            unsigned int max_entries)
> >>>>>>> +{
> >>>>>>> +       struct acpi_subtable_proc proc[1];
> >>>>>>> +
> >>>>>>> +       if (!handler)
> >>>>>>> +               return -EINVAL;
> >>>>>>> +
> >>>>>>> +       memset(proc, 0, sizeof(proc));
> >>>>>>> +       proc[0].id = entry_id;
> >>>>>>> +       proc[0].handler = handler;
> >>>>>>> +
> >>>>>>> +       return acpi_table_parse_entries_array(id, table_size, proc,
> >>>>>>1,
> >>>>>>> +                                                max_entries);
> >>>>>>>  }
> >>>>>>>
> >>>>>>>  int __init
> >>>>>>> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
> >>>>>>> ===================================================================
> >>>>>>> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
> >>>>>>> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
> >>>>>>> @@ -887,6 +887,7 @@ static int __init acpi_parse_madt_lapic_
> >>>>>>>  {
> >>>>>>>         int count;
> >>>>>>>         int x2count = 0;
> >>>>>>> +       struct acpi_subtable_proc madt_proc[2];
> >>>>>>>
> >>>>>>>         if (!cpu_has_apic)
> >>>>>>>                 return -ENODEV;
> >>>>>>> @@ -911,10 +912,16 @@ static int __init acpi_parse_madt_lapic_
> >>>>>>>                                       acpi_parse_sapic,
> >>>>>>MAX_LOCAL_APIC);
> >>>>>>>
> >>>>>>>         if (!count) {
> >>>>>>> -               x2count =
> >>>>>>acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
> >>>>>>> -                                       acpi_parse_x2apic,
> >>>>>>MAX_LOCAL_APIC);
> >>>>>>> -               count =
> >>>>>>acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
> >>>>>>> -                                       acpi_parse_lapic,
> >>>>>>MAX_LOCAL_APIC);
> >>>>>>> +               memset(madt_proc, 0, sizeof(madt_proc));
> >>>>>>> +               madt_proc[0].id = ACPI_MADT_TYPE_LOCAL_APIC;
> >>>>>>> +               madt_proc[0].handler = acpi_parse_lapic;
> >>>>>>> +               madt_proc[1].id = ACPI_MADT_TYPE_LOCAL_X2APIC;
> >>>>>>> +               madt_proc[1].handler = acpi_parse_x2apic;
> >>>>>>> +               acpi_table_parse_entries_array(ACPI_SIG_MADT,
> >>>>>>> +                                           sizeof(struct
> >>>>>>acpi_table_madt),
> >>>>>>> +                           madt_proc, ARRAY_SIZE(madt_proc),
> >>>>>>MAX_LOCAL_APIC);
> >>>>>>> +               count = madt_proc[0].count;
> >>>>>>> +               x2count = madt_proc[1].count;
> >>>>>>>         }
> >>>>>>>         if (!count && !x2count) {
> >>>>>>>                 printk(KERN_ERR PREFIX "No LAPIC entries present\n");
> >>>>>>> @@ -926,11 +933,16 @@ static int __init acpi_parse_madt_lapic_
> >>>>>>>                 return count;
> >>>>>>>         }
> >>>>>>>
> >>>>>>> -       x2count =
> >>>>>>> -           acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC_NMI,
> >>>>>>> -                                 acpi_parse_x2apic_nmi, 0);
> >>>>>>> -       count =
> >>>>>>> -           acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI,
> >>>>>>acpi_parse_lapic_nmi, 0);
> >>>>>>> +       memset(madt_proc, 0, sizeof(madt_proc));
> >>>>>>> +       madt_proc[0].id = ACPI_MADT_TYPE_LOCAL_APIC_NMI;
> >>>>>>> +       madt_proc[0].handler = acpi_parse_lapic_nmi;
> >>>>>>> +       madt_proc[1].id = ACPI_MADT_TYPE_LOCAL_X2APIC_NMI;
> >>>>>>> +       madt_proc[1].handler = acpi_parse_x2apic_nmi;
> >>>>>>> +       acpi_table_parse_entries_array(ACPI_SIG_MADT,
> >>>>>>> +                                   sizeof(struct acpi_table_madt),
> >>>>>>> +                                   madt_proc, ARRAY_SIZE(madt_proc),
> >>>>>>0);
> >>>>>>> +       count = madt_proc[0].count;
> >>>>>>> +       x2count = madt_proc[1].count;
> >>>>>>>         if (count < 0 || x2count < 0) {
> >>>>>>>                 printk(KERN_ERR PREFIX "Error parsing LAPIC NMI
> >>>>>>entry\n");
> >>>>>>>                 /* TBD: Cleanup to allow fallback to MPS */
> >>>>>>> Index: linux-2.6/drivers/acpi/numa.c
> >>>>>>> ===================================================================
> >>>>>>> --- linux-2.6.orig/drivers/acpi/numa.c
> >>>>>>> +++ linux-2.6/drivers/acpi/numa.c
> >>>>>>> @@ -294,10 +294,18 @@ int __init acpi_numa_init(void)
> >>>>>>>
> >>>>>>>         /* SRAT: Static Resource Affinity Table */
> >>>>>>>         if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
> >>>>>>> -
> >>>>>>acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
> >>>>>>> -                                    acpi_parse_x2apic_affinity, 0);
> >>>>>>> -               acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
> >>>>>>> -                                    acpi_parse_processor_affinity,
> >>>>>>0);
> >>>>>>> +               struct acpi_subtable_proc srat_proc[2];
> >>>>>>> +
> >>>>>>> +               memset(srat_proc, 0, sizeof(srat_proc));
> >>>>>>> +               srat_proc[0].id = ACPI_SRAT_TYPE_CPU_AFFINITY;
> >>>>>>> +               srat_proc[0].handler = acpi_parse_processor_affinity;
> >>>>>>> +               srat_proc[1].id = ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY;
> >>>>>>> +               srat_proc[1].handler = acpi_parse_x2apic_affinity;
> >>>>>>> +
> >>>>>>> +               acpi_table_parse_entries_array(ACPI_SIG_SRAT,
> >>>>>>> +                                          sizeof(struct
> >>>>>>acpi_table_srat),
> >>>>>>> +                                          srat_proc,
> >>>>>>ARRAY_SIZE(srat_proc), 0);
> >>>>>>> +
> >>>>>>>                 cnt =
> >>>>>>acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
> >>>>>>>
> >>>>>>acpi_parse_memory_affinity,
> >>>>>>>                                             NR_NODE_MEMBLKS);
> >>>>>>> Index: linux-2.6/include/linux/acpi.h
> >>>>>>> ===================================================================
> >>>>>>> --- linux-2.6.orig/include/linux/acpi.h
> >>>>>>> +++ linux-2.6/include/linux/acpi.h
> >>>>>>> @@ -87,6 +87,12 @@ static inline void acpi_initrd_override(
> >>>>>>>  }
> >>>>>>>  #endif
> >>>>>>>
> >>>>>>> +struct acpi_subtable_proc {
> >>>>>>> +       int id;
> >>>>>>> +       acpi_tbl_entry_handler handler;
> >>>>>>> +       int count;
> >>>>>>> +};
> >>>>>>> +
> >>>>>>>  char * __acpi_map_table (unsigned long phys_addr, unsigned long
> >>>>>>size);
> >>>>>>>  void __acpi_unmap_table(char *map, unsigned long size);
> >>>>>>>  int early_acpi_boot_init(void);
> >>>>>>> @@ -97,6 +103,9 @@ int acpi_numa_init (void);
> >>>>>>>
> >>>>>>>  int acpi_table_init (void);
> >>>>>>>  int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
> >>>>>>> +int acpi_table_parse_entries_array(char *id, unsigned long
> >>>>>>table_size,
> >>>>>>> +                       struct acpi_subtable_proc *proc, int
> >>>>>>proc_num,
> >>>>>>> +                       unsigned int max_entries);
> >>>>>>>  int __init acpi_table_parse_entries(char *id, unsigned long
> >>>>>>table_size,
> >>>>>>>                                     int entry_id,
> >>>>>>>                                     acpi_tbl_entry_handler handler,
> >>>>>>
> >>>>>>Hi, Raphael, Peter,
> >>>>>>
> >>>>>>Can you apply this one ?
> >>>>>>
> >>>>> I am away on vacation.
> >>>>>
> >>>>
> >>>> Can you put this one tip or acpi tree?
> >>
> >> Hi Peter,
> >>
> >> We found strange result from MLC on 8 sockets Westmere and Haswell.
> >>
> >> Intel(R) Memory Latency Checker - v2
> >>
> >> Using buffer size of 200.000MB
> >> Measuring idle latencies (in ns)...
> >>  Memory node
> >> Socket       0       1       2       3       4       5 6       7
> >>      0     9.3    25.1    30.0    24.3    11.9    28.2 29.6    26.4
> >>      1    25.1    10.0    24.8    25.7    29.8    20.8 29.1    23.4
> >>      2    29.6    19.4     9.3    25.1    27.9    29.1 22.5    29.7
> >>      3    22.3    29.8    22.0     9.2    24.7    29.9 23.9    25.0
> >>      4   243.9   286.5   273.4   275.0    87.3   230.0   229.9 278.8
> >>      5   299.7   223.1   277.9   270.2   232.8    86.4   286.4 224.6
> >>      6   274.8   274.1   224.3   279.8   225.6   281.7    87.0 232.2
> >>      7   296.2   273.6   280.8   218.6   280.6   226.8 233.3    87.1
> >>
> >> the root cause, that MLC has problem to parse strange order of cpu mapping.
> >>
> >> smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 #8 #9 #10
> >> #11 #12 #13 #14 #15 #16 #17 #18 OK
> >> smpboot: Booting Node   1, Processors  #19 #20 #21 #22 #23 #24 #25 #26
> >> #27 #28 #29 #30 #31 #32 #33 #34 #35 #36 OK
> >> smpboot: Booting Node   2, Processors  #37 #38 #39 #40 #41 #42 #43 #44
> >> #45 #46 #47 #48 #49 #50 #51 #52 #53 #54 OK
> >> smpboot: Booting Node   3, Processors  #55 #56 #57 #58 #59 #60 #61 #62
> >> #63 #64 #65 #66 #67 #68 #69 #70 #71 #72 OK
> >> smpboot: Booting Node   0, Processors  #73 #74 #75 #76 #77 #78 #79 #80
> >> #81 #82 #83 #84 #85 #86 #87 #88 #89 #90 OK
> >> smpboot: Booting Node   1, Processors  #91 #92 #93 #94 #95 #96 #97 #98
> >> #99 #100 #101 #102 #103 #104 #105 #106 #107 #108 OK
> >> smpboot: Booting Node   2, Processors  #109 #110 #111 #112 #113 #114
> >> #115 #116 #117 #118 #119 #120 #121 #122 #123 #124 #125 #126 OK
> >> smpboot: Booting Node   3, Processors  #127 #128 #129 #130 #131 #132
> >> #133 #134 #135 #136 #137 #138 #139 #140 #141 #142 #143 #144 OK
> >> smpboot: Booting Node   4, Processors  #145 #146 #147 #148 #149 #150
> >> #151 #152 #153 #154 #155 #156 #157 #158 #159 #160 #161 OK
> >> smpboot: Booting Node   5, Processors  #162 #163 #164 #165 #166 #167
> >> #168 #169 #170 #171 #172 #173 #174 #175 #176 #177 #178 #179 OK
> >> smpboot: Booting Node   6, Processors  #180 #181 #182 #183 #184 #185
> >> #186 #187 #188 #189 #190 #191 #192 #193 #194 #195 #196 #197 OK
> >> smpboot: Booting Node   7, Processors  #198 #199 #200 #201 #202 #203
> >> #204 #205 #206 #207 #208 #209 #210 #211 #212 #213 #214 #215 OK
> >> smpboot: Booting Node   4, Processors  #216 #217 #218 #219 #220 #221
> >> #222 #223 #224 #225 #226 #227 #228 #229 #230 #231 #232 #233 OK
> >> smpboot: Booting Node   5, Processors  #234 #235 #236 #237 #238 #239
> >> #240 #241 #242 #243 #244 #245 #246 #247 #248 #249 #250 #251 OK
> >> smpboot: Booting Node   6, Processors  #252 #253 #254 #255 #256 #257
> >> #258 #259 #260 #261 #262 #263 #264 #265 #266 #267 #268 #269 OK
> >> smpboot: Booting Node   7, Processors  #270 #271 #272 #273 #274 #275
> >> #276 #277 #278 #279 #280 #281 #282 #283 #284 #285 #286 #287 OK
> >> Brought up 288 CPUs
> >>
> >> CPU0 is on Node 4. that confuse MLC wrapper....assume it can not handle
> >> node4: 0, 145-161, 216-233
> >> ...
> >>
> >> BIOS keep CPU entries with xapic and x2apic in order according acpi spec,
> >> but kernel will parse x2apic before xapic and same time keep cpu0
> >> always on socket0
> >> aka node 4 here.
> >>
> >> solution would be
> >> 1. fix MLC to make it more smart
> >> 2. at same time it would be good to apply this patch to mainline
> >> kernel, that will make user life more easy
> >> with sane cpu mapping.
> >>
> >> So please put this patch into tip or acpi tree.
> >>
> >> Thanks
> >>
> >> Yinghai
