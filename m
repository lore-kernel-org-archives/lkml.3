Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3IAKBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:01:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41020 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3IAKBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:01:14 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com>
	<1375758759-29629-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<CA+55aFxvEjdEFK0dXn783eVN0PEXVhb5k8OnrbxSWDpXgyTwWw@mail.gmail.com>
	<CA+icZUXcn6-A+AW5bu_pfRdOcScsNyn3-OZe6n93S5NUEzHtcg@mail.gmail.com>
	<CA+55aFwHx=tCzdo50jJB0ey7-CTVSo6RRQHe6R9fAya7nPn00A@mail.gmail.com>
	<CA+icZUWmQHWHMr1symL7j0iYqUMJBiOuRJ=EJz4F-xkQtdnJLg@mail.gmail.com>
	<CA+55aFxwjx30pC=kcfvOzgJvt2KK9DLm2i6JKYYz+mtOOJEnMA@mail.gmail.com>
Date: Sun, 1 Sep 2013 12:01:12 +0200
Message-ID: <CA+icZUUwy=sbt6BOirH6N4mSrQOykb=Z3GSdCb7vy_eVfG2RYw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: multipart/mixed; boundary=e89a8f50348228f97a04e54f8909
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f50348228f97a04e54f8909
Content-Type: text/plain; charset=UTF-8

On Fri, Aug 30, 2013 at 6:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Aug 30, 2013 at 9:37 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>
>> Where is this a.out file from or how to generate it?
>
> Oh, that's just the silly threaded test-binary. I don't know what you
> called it.
>
> As to your config options, yesh, you have some expensive stuff.
> DEBUG_OBJECTS and DEBUG_MUTEXES in particular tend to cause lots of
> horrible performance issues. I didn't check if there might be other
> things..
>

I tried w/o DEBUG_OBJECTS and DEBUG_MUTEXES and disabled some
unnecessary debug-options, too (see attached diff).

This is what I get now...

[ TEST-CASE ]

$ ~/src/linux-kernel/linux/tools/perf/perf stat --null --repeat 5
./scripts/t_lockref_from-linus
Total loops: 26480075
Total loops: 27002388
Total loops: 25761463
Total loops: 26877615
Total loops: 27047644

 Performance counter stats for './scripts/t_lockref_from-linus' (5 runs):

      10,008617789 seconds time elapsed
          ( +-  0,07% )


Looks like this is now 10x faster: ~2.66Mloops (debug) VS.
~26.60Mloops (no-debug).

[ PERF-RECORD ]

$ sudo ~/src/linux-kernel/linux/tools/perf/perf record -e cycles:pp
./scripts/t_lockref_from-linus
Total loops: 26601346
[ perf record: Woken up 25 times to write data ]
[ perf record: Captured and wrote 6.100 MB perf.data (~266501 samples) ]

[ PERF-REPORT ]

$ sudo ~/src/linux-kernel/linux/tools/perf/perf report -f

Samples: 159K of event 'cycles:pp', Event count (approx.): 76968896763
 12,79%  t_lockref_from-  [kernel.kallsyms]     [k] irq_return
  4,36%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_lock
  4,36%  t_lockref_from-  [kernel.kallsyms]     [k] __acct_update_integrals
  4,07%  t_lockref_from-  [kernel.kallsyms]     [k] user_exit
  3,12%  t_lockref_from-  [kernel.kallsyms]     [k] local_clock
  2,83%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_get_or_lock
  2,73%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_alloc
  2,62%  t_lockref_from-  [kernel.kallsyms]     [k] __d_lookup_rcu
  2,53%  t_lockref_from-  libc-2.15.so          [.] __xstat64
  2,53%  t_lockref_from-  [kernel.kallsyms]     [k] kmem_cache_free
  2,28%  t_lockref_from-  [kernel.kallsyms]     [k] path_init
  2,27%  t_lockref_from-  [kernel.kallsyms]     [k] link_path_walk
  1,86%  t_lockref_from-  [kernel.kallsyms]     [k] user_enter
  1,85%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_exit_common.isra.43
  1,81%  t_lockref_from-  [kernel.kallsyms]     [k] sched_clock_cpu
  1,79%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_enter_common.isra.45
  1,78%  t_lockref_from-  [kernel.kallsyms]     [k] path_lookupat
  1,67%  t_lockref_from-  [kernel.kallsyms]     [k] native_read_tsc
  1,63%  t_lockref_from-  [kernel.kallsyms]     [k] cp_new_stat
  1,61%  t_lockref_from-  [kernel.kallsyms]     [k] lockref_put_or_lock
  1,53%  t_lockref_from-  [kernel.kallsyms]     [k] account_system_time
  1,48%  t_lockref_from-  [kernel.kallsyms]     [k] tracesys
  1,47%  t_lockref_from-  [kernel.kallsyms]     [k] copy_user_generic_unrolled
  1,46%  t_lockref_from-  [kernel.kallsyms]     [k] syscall_trace_enter
  1,39%  t_lockref_from-  [kernel.kallsyms]     [k] jiffies_to_timeval
  1,33%  t_lockref_from-  [kernel.kallsyms]     [k] native_sched_clock
  1,27%  t_lockref_from-  [kernel.kallsyms]     [k] getname_flags
  1,27%  t_lockref_from-  [kernel.kallsyms]     [k] lookup_fast
  1,18%  t_lockref_from-  [kernel.kallsyms]     [k] get_vtime_delta
  1,05%  t_lockref_from-  [kernel.kallsyms]     [k] syscall_trace_leave
  1,03%  t_lockref_from-  [kernel.kallsyms]     [k] generic_fillattr
  1,02%  t_lockref_from-  [kernel.kallsyms]     [k] strncpy_from_user
  1,00%  t_lockref_from-  [kernel.kallsyms]     [k] user_path_at_empty
  0,97%  t_lockref_from-  [kernel.kallsyms]     [k] account_user_time
  0,95%  t_lockref_from-  [kernel.kallsyms]     [k] vfs_fstatat
  0,95%  t_lockref_from-  [kernel.kallsyms]     [k] system_call_after_swapgs
  0,92%  t_lockref_from-  [kernel.kallsyms]     [k] generic_permission
  0,91%  t_lockref_from-  [kernel.kallsyms]     [k] filename_lookup
  0,80%  t_lockref_from-  [kernel.kallsyms]     [k] vfs_getattr
  0,78%  t_lockref_from-  [kernel.kallsyms]     [k] __ticket_spin_unlock
  0,74%  t_lockref_from-  [kernel.kallsyms]     [k] complete_walk
  0,70%  t_lockref_from-  [kernel.kallsyms]     [k] vtime_account_user
  0,68%  t_lockref_from-  [kernel.kallsyms]     [k] d_rcu_to_refcount
  0,65%  t_lockref_from-  [kernel.kallsyms]     [k] common_perm
  0,62%  t_lockref_from-  [kernel.kallsyms]     [k] rcu_eqs_enter
  0,58%  t_lockref_from-  [kernel.kallsyms]     [k] vtime_user_enter
  0,57%  t_lockref_from-  [kernel.kallsyms]     [k] __inode_permission
  0,55%  t_lockref_from-  [kernel.kallsyms]     [k] dput
  0,52%  t_lockref_from-  [kernel.kallsyms]     [k] apparmor_inode_getattr
  0,52%  t_lockref_from-  [kernel.kallsyms]     [k] SYSC_newstat
  0,52%  t_lockref_from-  [kernel.kallsyms]     [k] mntget
  0,49%  t_lockref_from-  [kernel.kallsyms]     [k] cpuacct_account_field
  0,48%  t_lockref_from-  [kernel.kallsyms]     [k] __vtime_account_system
  0,46%  t_lockref_from-  t_lockref_from-linus  [.] start_routine

Thanks for all the explanations and hints.

Regards,
- Sedat -

P.S.: Some words to "perf -f"...

$ sudo ~/src/linux-kernel/linux/tools/perf/perf record -f -e cycles:pp
./scripts/t_lockref_from-linus
[sudo] password for wearefam:
  Error: unknown switch `f'

 usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]

    -e, --event <event>   event selector. use 'perf list' to list
available events
        --filter <filter>
                          event filter
    -p, --pid <pid>       record events on existing process id
    -t, --tid <tid>       record events on existing thread id
    -r, --realtime <n>    collect data with this RT SCHED_FIFO priority
    -D, --no-delay        collect data without buffering
    -R, --raw-samples     collect raw sample records from all opened counters
    -a, --all-cpus        system-wide collection from all CPUs
    -C, --cpu <cpu>       list of cpus to monitor
    -c, --count <n>       event period to sample
    -o, --output <file>   output file name
    -i, --no-inherit      child tasks do not inherit counters
    -F, --freq <n>        profile at this frequency
    -m, --mmap-pages <n>  number of mmap data pages
        --group           put the counters into a counter group
    -g, --call-graph <mode[,dump_size]>
                          do call-graph (stack chain/backtrace)
recording: [fp] dwarf
    -v, --verbose         be more verbose (show counter open errors, etc)
    -q, --quiet           don't print any message
    -s, --stat            per thread counts
    -d, --data            Sample addresses
    -T, --timestamp       Sample timestamps
    -P, --period          Sample period
    -n, --no-samples      don't sample
    -N, --no-buildid-cache
                          do not update the buildid cache
    -B, --no-buildid      do not collect buildids in perf.data
    -G, --cgroup <name>   monitor event in cgroup name only
    -u, --uid <user>      user to profile
    -b, --branch-any      sample any taken branches
    -j, --branch-filter <branch filter mask>
                          branch stack filter modes
    -W, --weight          sample by weight (on special events only)

- EOT -

--e89a8f50348228f97a04e54f8909
Content-Type: application/octet-stream; name="kernel-config.diff"
Content-Disposition: attachment; filename="kernel-config.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl230gnr0

LS0tIC9ib290L2NvbmZpZy0zLjExLjAtcmM3LTEtbG9ja3JlZi1zbWFsbAkyMDEzLTA4LTMwIDEw
OjIzOjQyLjAwMDAwMDAwMCArMDIwMAorKysgL2Jvb3QvY29uZmlnLTMuMTEuMC1yYzctMy1sb2Nr
cmVmLXNtYWxsCTIwMTMtMDktMDEgMTE6MjM6MjEuMDAwMDAwMDAwICswMjAwCkBAIC0zNTEsNiAr
MzUxLDcgQEAgQ09ORklHX0lOTElORV9SRUFEX1VOTE9DSz15CiBDT05GSUdfSU5MSU5FX1JFQURf
VU5MT0NLX0lSUT15CiBDT05GSUdfSU5MSU5FX1dSSVRFX1VOTE9DSz15CiBDT05GSUdfSU5MSU5F
X1dSSVRFX1VOTE9DS19JUlE9eQorQ09ORklHX01VVEVYX1NQSU5fT05fT1dORVI9eQogQ09ORklH
X0ZSRUVaRVI9eQogCiAjCkBAIC01NDIsMTEgKzU0Myw3IEBAIENPTkZJR19QTV9TTEVFUF9TTVA9
eQogIyBDT05GSUdfUE1fV0FLRUxPQ0tTIGlzIG5vdCBzZXQKIENPTkZJR19QTV9SVU5USU1FPXkK
IENPTkZJR19QTT15Ci1DT05GSUdfUE1fREVCVUc9eQotIyBDT05GSUdfUE1fQURWQU5DRURfREVC
VUcgaXMgbm90IHNldAotIyBDT05GSUdfUE1fVEVTVF9TVVNQRU5EIGlzIG5vdCBzZXQKLUNPTkZJ
R19QTV9TTEVFUF9ERUJVRz15Ci0jIENPTkZJR19QTV9UUkFDRV9SVEMgaXMgbm90IHNldAorIyBD
T05GSUdfUE1fREVCVUcgaXMgbm90IHNldAogIyBDT05GSUdfV1FfUE9XRVJfRUZGSUNJRU5UX0RF
RkFVTFQgaXMgbm90IHNldAogQ09ORklHX0FDUEk9eQogQ09ORklHX0FDUElfU0xFRVA9eQpAQCAt
MTYyNSw5ICsxNjIyLDggQEAgQ09ORklHX0lXTFdJRklfT1BNT0RFX01PRFVMQVI9eQogIwogIyBE
ZWJ1Z2dpbmcgT3B0aW9ucwogIwotQ09ORklHX0lXTFdJRklfREVCVUc9eQorIyBDT05GSUdfSVdM
V0lGSV9ERUJVRyBpcyBub3Qgc2V0CiBDT05GSUdfSVdMV0lGSV9ERUJVR0ZTPXkKLSMgQ09ORklH
X0lXTFdJRklfREVCVUdfRVhQRVJJTUVOVEFMX1VDT0RFIGlzIG5vdCBzZXQKIENPTkZJR19JV0xX
SUZJX0RFVklDRV9UUkFDSU5HPXkKIENPTkZJR19JV0xXSUZJX1AyUD15CiAjIENPTkZJR19JV0w0
OTY1IGlzIG5vdCBzZXQKQEAgLTMxODEsNyArMzE3Nyw3IEBAIENPTkZJR19VU0JfU1VQUE9SVD15
CiBDT05GSUdfVVNCX0NPTU1PTj15CiBDT05GSUdfVVNCX0FSQ0hfSEFTX0hDRD15CiBDT05GSUdf
VVNCPXkKLUNPTkZJR19VU0JfREVCVUc9eQorIyBDT05GSUdfVVNCX0RFQlVHIGlzIG5vdCBzZXQK
IENPTkZJR19VU0JfQU5OT1VOQ0VfTkVXX0RFVklDRVM9eQogCiAjCkBAIC0zNzQzLDExICszNzM5
LDExIEBAIENPTkZJR19FWFQ0X0ZTPXkKIENPTkZJR19FWFQ0X1VTRV9GT1JfRVhUMjM9eQogQ09O
RklHX0VYVDRfRlNfUE9TSVhfQUNMPXkKIENPTkZJR19FWFQ0X0ZTX1NFQ1VSSVRZPXkKLUNPTkZJ
R19FWFQ0X0RFQlVHPXkKKyMgQ09ORklHX0VYVDRfREVCVUcgaXMgbm90IHNldAogQ09ORklHX0pC
RD15CiAjIENPTkZJR19KQkRfREVCVUcgaXMgbm90IHNldAogQ09ORklHX0pCRDI9eQotQ09ORklH
X0pCRDJfREVCVUc9eQorIyBDT05GSUdfSkJEMl9ERUJVRyBpcyBub3Qgc2V0CiBDT05GSUdfRlNf
TUJDQUNIRT15CiAjIENPTkZJR19SRUlTRVJGU19GUyBpcyBub3Qgc2V0CiAjIENPTkZJR19KRlNf
RlMgaXMgbm90IHNldApAQCAtMzk1NSwyMiArMzk1MSwxNCBAQCBDT05GSUdfREVCVUdfS0VSTkVM
PXkKICMgTWVtb3J5IERlYnVnZ2luZwogIwogIyBDT05GSUdfREVCVUdfUEFHRUFMTE9DIGlzIG5v
dCBzZXQKLUNPTkZJR19ERUJVR19PQkpFQ1RTPXkKLSMgQ09ORklHX0RFQlVHX09CSkVDVFNfU0VM
RlRFU1QgaXMgbm90IHNldAotIyBDT05GSUdfREVCVUdfT0JKRUNUU19GUkVFIGlzIG5vdCBzZXQK
LSMgQ09ORklHX0RFQlVHX09CSkVDVFNfVElNRVJTIGlzIG5vdCBzZXQKLSMgQ09ORklHX0RFQlVH
X09CSkVDVFNfV09SSyBpcyBub3Qgc2V0Ci1DT05GSUdfREVCVUdfT0JKRUNUU19SQ1VfSEVBRD15
Ci0jIENPTkZJR19ERUJVR19PQkpFQ1RTX1BFUkNQVV9DT1VOVEVSIGlzIG5vdCBzZXQKLUNPTkZJ
R19ERUJVR19PQkpFQ1RTX0VOQUJMRV9ERUZBVUxUPTEKLUNPTkZJR19ERUJVR19TTEFCPXkKLSMg
Q09ORklHX0RFQlVHX1NMQUJfTEVBSyBpcyBub3Qgc2V0CisjIENPTkZJR19ERUJVR19PQkpFQ1RT
IGlzIG5vdCBzZXQKKyMgQ09ORklHX0RFQlVHX1NMQUIgaXMgbm90IHNldAogQ09ORklHX0hBVkVf
REVCVUdfS01FTUxFQUs9eQogIyBDT05GSUdfREVCVUdfS01FTUxFQUsgaXMgbm90IHNldAogIyBD
T05GSUdfREVCVUdfU1RBQ0tfVVNBR0UgaXMgbm90IHNldAogIyBDT05GSUdfREVCVUdfVk0gaXMg
bm90IHNldAogIyBDT05GSUdfREVCVUdfVklSVFVBTCBpcyBub3Qgc2V0Ci1DT05GSUdfREVCVUdf
TUVNT1JZX0lOSVQ9eQorIyBDT05GSUdfREVCVUdfTUVNT1JZX0lOSVQgaXMgbm90IHNldAogIyBD
T05GSUdfREVCVUdfUEVSX0NQVV9NQVBTIGlzIG5vdCBzZXQKIENPTkZJR19IQVZFX0RFQlVHX1NU
QUNLT1ZFUkZMT1c9eQogIyBDT05GSUdfREVCVUdfU1RBQ0tPVkVSRkxPVyBpcyBub3Qgc2V0CkBA
IC00MDAyLDcgKzM5OTAsNyBAQCBDT05GSUdfVElNRVJfU1RBVFM9eQogIyBDT05GSUdfREVCVUdf
UlRfTVVURVhFUyBpcyBub3Qgc2V0CiAjIENPTkZJR19SVF9NVVRFWF9URVNURVIgaXMgbm90IHNl
dAogIyBDT05GSUdfREVCVUdfU1BJTkxPQ0sgaXMgbm90IHNldAotQ09ORklHX0RFQlVHX01VVEVY
RVM9eQorIyBDT05GSUdfREVCVUdfTVVURVhFUyBpcyBub3Qgc2V0CiAjIENPTkZJR19ERUJVR19X
V19NVVRFWF9TTE9XUEFUSCBpcyBub3Qgc2V0CiAjIENPTkZJR19ERUJVR19MT0NLX0FMTE9DIGlz
IG5vdCBzZXQKICMgQ09ORklHX1BST1ZFX0xPQ0tJTkcgaXMgbm90IHNldAo=
--e89a8f50348228f97a04e54f8909--
