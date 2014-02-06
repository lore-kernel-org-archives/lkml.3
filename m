Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaBFJu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:50:59 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45723 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbaBFJu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:50:56 -0500
Message-ID: <52F35AF9.4050505@hitachi.com>
Date: Thu, 06 Feb 2014 18:50:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip ] [BUGFIX/URGENT] perf-probe: Do not add offset to
 uprobe address
References: <20140205051858.6519.27314.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp> <871tzg1y31.fsf@sejong.aot.lge.com>
In-Reply-To: <871tzg1y31.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/02/06 16:48), Namhyung Kim wrote:
> Hi Masami,
> 
> On Wed, 05 Feb 2014 05:18:58 +0000, Masami Hiramatsu wrote:
>> Fix perf-probe not to add offset value to uprobe probe
>> address when post processing.
>> tevs[i].point.address is the address of symbol+offset,
>> but current perf-probe adjusts the point.address by
>> adding the offset. As a result, the probe address becomes
>> symbol+offset+offset. This may cause unexpected
>> code corruption. Urgent fix is needed.
>>
>> Without this fix
>>   ---
>>   # ./perf probe -x ./perf dso__load_vmlinux+4
>>   # ./perf probe -l
>>     probe_perf:dso__load_vmlinux (on 0x000000000006d2b8)
>>   # nm ./perf.orig | grep dso__load_vmlinux\$
>>   000000000046d0a0 T dso__load_vmlinux
> 
> Shouldn't the original symbol address be
> 
>     000000000046d2b0

Oops, Yes, I missed my ./perf and ./perf.orig...
Since the uprobe doesn't track binary change, I usually use a
copy of original binary. Here is the correct test results;


Without this fix
  ---
  # ./perf probe -x ./perf.orig dso__load_vmlinux+4
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on 0x000000000006d2b8)
  # nm ./perf.orig | grep dso__load_vmlinux\$
  000000000046d2b0 T dso__load_vmlinux
  ---
You can see the given offset is 4 but the actual probed
address is dso__load_vmlinux+8.

With this fix
  ---
  # ./perf probe -x ./perf.orig dso__load_vmlinux+4
  # ./perf probe -l
    probe_perf:dso__load_vmlinux (on 0x000000000006d2b4)
  ---
Now the problem is fixed.


> 
>>   ---
>> You can see the given offset is 3 but the actual probed
> 
> s/3/4/ ?

Yes, it's a typo. :(

Thank you!!



-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


