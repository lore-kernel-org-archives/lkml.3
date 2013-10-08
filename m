Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3JHGEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:04:06 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46517 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3JHGEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:04:04 -0400
Message-ID: <5253A04E.4020809@hitachi.com>
Date: Tue, 08 Oct 2013 15:03:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hkshaw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        namhyung@kernel.org, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] Perf support to SDT markers
References: <20131007063911.11693.33624.stgit@hemant-fedora>
In-Reply-To: <20131007063911.11693.33624.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2013/10/07 15:46), Hemant Kumar wrote:
> This patchset helps in probing dtrace style markers(SDT) present in user space
> applications through perf. Notes/markes are placed at important places by the
> developers. They have a negligible overhead when not enabled. We can enable
> them and probe at these places and find some important information like the
> arguments' values, etc.

Thank you for updating!
By the way, could you rebase this series to the latest -tip kernel next time?
It is more convenient for us to test & merge it.

[...]
> - Now use perf to list the markers in the app:
> # perf probe --markers -x ./user_app
> 
> %user_app:foo_start
> %user_app:fun_start

Here, what I got.

$ ./perf probe --markers -x /lib64/librt.so
%librt:lll_futex_wake

OK, it lists up markers.

$ ./perf probe --markers -x ./perf
SDT markers not present!
  Error : Failed to find SDT markers!(-1)

OK, this shows an error, INHO, it'd better show which binary doesn't have markers.

$ ./perf probe --markers
Failed to open (null)
  Error : Failed to find SDT markers!(-1)

Hmm, it's a bit odd error. It should check if there is an elf binary is specified.

$ ./perf probe --markers /lib64/librt.so
%librt:lll_futex_wake

It seems to work without -x. However, that is only when the path is started with /.
And also the usage is not described by --help.

$ ./perf probe --markers ./perf
Semantic error :File always requires line number or lazy pattern.
  Error: Parse Error.  (-22)

So, to avoid confusion, --markers should abort without -x(--exec) option.

> - And  then use perf probe to add a probe point :
> 
> # perf probe -x ./user_app -a '%user_app:foo_start'

And also, without -x, -a also exits with an odd error message.

$ ./perf probe -a %libm:slowexp_p6
Failed to open (null)
  Error: Failed to add events. (-1)

I'll review each patch soon.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


