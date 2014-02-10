Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaBJOYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:24:12 -0500
Received: from [207.46.163.210] ([207.46.163.210]:29653 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751920AbaBJOYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:24:07 -0500
From: "Kulkarni, Ganapatrao" <Ganapatrao.Kulkarni@caviumnetworks.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "tim.bird@sonymobile.com" <tim.bird@sonymobile.com>
CC: "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: RE: [PATCH v3 0/6] arm64: Add ftrace support
Thread-Topic: [PATCH v3 0/6] arm64: Add ftrace support
Thread-Index: AQHPI+4la7hX7bpUwUqO6wIN/ttIKpqujZgv
Date: Mon, 10 Feb 2014 14:21:55 +0000
Message-ID: <3f2fe6c79a0f439c84f593b124895f10@BLUPR07MB449.namprd07.prod.outlook.com>
References: <1382598488-13511-1-git-send-email-takahiro.akashi@linaro.org>,<1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
In-Reply-To: <1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [115.119.134.194]
x-forefront-prvs: 0118CD8765
x-forefront-antispam-report: SFV:NSPM;SFS:(10019001)(6009001)(377454003)(189002)(199002)(76786001)(76796001)(76576001)(81542001)(81342001)(85306002)(2201001)(92566001)(83072002)(85852003)(56816005)(90146001)(94316002)(86362001)(94946001)(93516002)(93136001)(80976001)(83322001)(19580395003)(95416001)(33646001)(81816001)(81686001)(74366001)(74316001)(47446002)(74662001)(74502001)(87266001)(49866001)(4396001)(47736001)(50986001)(47976001)(80022001)(79102001)(77982001)(87936001)(59766001)(66066001)(2656002)(19580405001)(74876001)(63696002)(65816001)(74706001)(76482001)(46102001)(54316002)(51856001)(69226001)(31966008)(54356001)(53806001)(56776001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB452;H:BLUPR07MB449.namprd07.prod.outlook.com;CLIP:115.119.134.194;FPR:CD3170EE.A4EA8FE8.67D36147.CCC9EA46.20483;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks OK to me.

Reviewed-by: Ganapatrao Kulkarni <ganapatrao.kulkarni@cavium.com>

regards,
Ganapat

________________________________________
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Sent: Friday, February 7, 2014 3:48 PM
To: rostedt@goodmis.org; fweisbec@gmail.com; mingo@redhat.com; catalin.marinas@arm.com; will.deacon@arm.com; Kulkarni, Ganapatrao; tim.bird@sonymobile.com
Cc: arndb@arndb.de; linux-arm-kernel@lists.infradead.org; linaro-kernel@lists.linaro.org; linux-kernel@vger.kernel.org; patches@linaro.org; AKASHI Takahiro
Subject: [PATCH v3 0/6] arm64: Add ftrace support

This is my third version of patchset for ftrace support.
There was another implementation from Cavium network, but both of us agreed
to use my patchset as future base. He is supposed to review this code, too.

The only issue that I had some concern on was "fault protection" code
in prepare_ftrace_return(). With discussions with Steven and Tim (as author
of arm ftrace), I removed that code since I'm not quite sure about possibility
of "fault" occurrences in this function.

The code is tested on ARMv8 Fast Model with the following tracers & events:
     function tracer with dynamic ftrace
     function graph tracer with dynamic ftrace
     syscall tracepoint
     irqsoff & preemptirqsoff (which use CALLER_ADDRx)
and also verified with in-kernel tests, FTRACE_SELFTEST, FTRACE_STARTUP_TEST
and EVENT_TRACE_TEST_SYSCALLS.

Please be careful:
* elf.h on cross-build host must have AArch64 definitions, EM_AARCH64 and
  R_AARCH64_ABS64, to compile recordmcount utility. See [4/6].
  [4/6] also gets warnings from checkpatch, but they are based on the
  original's coding style.
* This patch may conflict with my audit patch because both changes the same
  location in syscall_trace(). I expect the functions are called in this
  order:
  On entry,
     * tracehook_report_syscall(ENTER)
     * trace_sys_enter()
     * audit_syscall_entry()
  On exit,
     * audit_sysscall_exit()
     * trace_sys_exit()
     * tracehook_report_syscall(EXIT)

Changes from v1 to v2:
* splitted one patch into some pieces for easier review
  (especially function tracer + dynamic ftrace + CALLER_ADDRx)
* put return_address() in a separate file
* renamed __mcount to _mcount (it was my mistake)
* changed stackframe handling to get parent's frame pointer
* removed ARCH_SUPPORTS_FTRACE_OPS
* switched to "hotpatch" interfaces from Huawai
* revised descriptions in comments

Changes from v2 to v3:
* optimized register usages in asm (by not saving x0, x1, and x2)
* removed "fault protection" code in prepare_ftrace_return()
* rewrote ftrace_modify_code() using "hotpatch" interfaces
* revised descriptions in comments

AKASHI Takahiro (6):
  arm64: Add ftrace support
  arm64: ftrace: Add dynamic ftrace support
  arm64: ftrace: Add CALLER_ADDRx macros
  ftrace: Add arm64 support to recordmcount
  arm64: ftrace: Add system call tracepoint
  arm64: Add 'notrace' attribute to unwind_frame() for ftrace

 arch/arm64/Kconfig                 |    6 +
 arch/arm64/include/asm/ftrace.h    |   54 +++++++++
 arch/arm64/include/asm/syscall.h   |    1 +
 arch/arm64/include/asm/unistd.h    |    2 +
 arch/arm64/kernel/Makefile         |    9 +-
 arch/arm64/kernel/arm64ksyms.c     |    4 +
 arch/arm64/kernel/entry-ftrace.S   |  215 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/ftrace.c         |  177 +++++++++++++++++++++++++++++
 arch/arm64/kernel/ptrace.c         |    5 +
 arch/arm64/kernel/return_address.c |   55 +++++++++
 arch/arm64/kernel/stacktrace.c     |    2 +-
 scripts/recordmcount.c             |    4 +
 scripts/recordmcount.pl            |    5 +
 13 files changed, 537 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/ftrace.h
 create mode 100644 arch/arm64/kernel/entry-ftrace.S
 create mode 100644 arch/arm64/kernel/ftrace.c
 create mode 100644 arch/arm64/kernel/return_address.c

--
1.7.9.5

