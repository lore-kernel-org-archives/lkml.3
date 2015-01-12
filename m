Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbbALMAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:00:10 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:48660 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbALMAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:00:08 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@redhat.com" <acme@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Alexey.Brodkin@synopsys.com" <Alexey.Brodkin@synopsys.com>
Subject: Re: [PATCH v2 3/5] perf tools: [uclibc] Avoid build splat for
 syscall numbers
Thread-Topic: [PATCH v2 3/5] perf tools: [uclibc] Avoid build splat for
 syscall numbers
Thread-Index: AQHQLlhCspcOCVl0p0SSVinnfeP6Iw==
Date: Mon, 12 Jan 2015 12:00:02 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BCBA99@IN01WEMBXA.internal.synopsys.com>
References: <1420888254-17504-1-git-send-email-vgupta@synopsys.com>
 <1420888254-17504-4-git-send-email-vgupta@synopsys.com>
 <20150112110907.GD26229@krava.redhat.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Monday 12 January 2015 04:39 PM, Jiri Olsa wrote:
> On Sat, Jan 10, 2015 at 04:40:52PM +0530, Vineet Gupta wrote:
>> This is due to duplicated unistd inclusion (via uClibc headers + kernel headers)
>> Also seen on ARM uClibc based tools
>>
>> ------- ARC build ---------->8-------------
>>
>>   CC       util/evlist.o
>> In file included from
>> ~/arc/k.org/arch/arc/include/uapi/asm/unistd.h:25:0,
>>                  from util/../perf-sys.h:10,
>>                  from util/../perf.h:15,
>>                  from util/event.h:7,
>>                  from util/event.c:3:
>> ~/arc/k.org/include/uapi/asm-generic/unistd.h:906:0:
>> warning: "__NR_fcntl64" redefined [enabled by default]
>>  #define __NR_fcntl64 __NR3264_fcntl
>>  ^
>> In file included from
>> ~/arc/gnu/INSTALL_1412-arc-2014.12-rc1/arc-snps-linux-uclibc/sysroot/usr/include/sys/syscall.h:24:0,
>>                  from util/../perf-sys.h:6,
>> ----------------->8-------------------
>>
>> ------- ARM build ---------->8-------------
>>
>>   CC FPIC  plugin_scsi.o
>> In file included from util/../perf-sys.h:9:0,
>>                  from util/../perf.h:15,
>>                  from util/cache.h:7,
>>                  from perf.c:12:
>> ~/arc/k.org/arch/arm/include/uapi/asm/unistd.h:28:0:
>> warning: "__NR_restart_syscall" redefined [enabled by default]
>> In file included from
>> ~/buildroot/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/sys/syscall.h:25:0,
>>                  from util/../perf-sys.h:6,
>>                  from util/../perf.h:15,
>>                  from util/cache.h:7,
>>                  from perf.c:12:
>> ~/buildroot/host/usr/arm-buildroot-linux-uclibcgnueabi/sysroot/usr/include/bits/sysnum.h:17:0:
>> note: this is the location of the previous definition
>> ----------------->8-------------------
> Could you please point out what's the right logic for including those headers?

I'm not sure why you were including <linux/unistd.h> in first place. Vanilla
<unistd.h> shd suffice for the functions exported by that file. OTOH, if the
intent was to get SYS_xxx or NR_xxx, then per syscall man page, <sys/syscall.h> is
the recommended way.

I just tried a small test program which uses __NR_restart_syscall for both x86
(glibc) and ARC (uClibc) and including <sys/syscall.h> seems to work.

Also replacing <linux/unistd.h> with <sys/syscall.h> in the first 2 hunks of this
patch equally fixes my perf build splat. The 3rd one (perf-sys.h) already includes
<sys/syscall.h> so no change required there.

I'll send out a v3 to same effect.

>
> I've always thought that just adding:
>
>   #include <linux/unistd.h>
>
> should be safe no matter what.. feels like bug in one of those
> header files? (uClibc headers & kernel headers)

Well the design of asm-generic/unistd.h (no legacy syscalls ABI) which ARC uses
does require duplicate inclusion of asm/unistd.h so a simple guard in header is
not sufficient (and actually caused me embarrassing grief when I naively submitted
that into mainline some time last year)

Thx,
-Vineet

>
> thanks for info,
> jirka

