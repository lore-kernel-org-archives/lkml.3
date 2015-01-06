Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbbAFPZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:25:52 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:62081 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbAFPZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:25:50 -0500
Message-ID: <54ABFE7F.6090904@linaro.org>
Date: Tue, 06 Jan 2015 15:25:51 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Kiran Raparthy <kiran.kumar@linaro.org>
CC: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v4] debug: prevent entering debug mode on panic/exception.
References: <1419338309-16729-1-git-send-email-kiran.kumar@linaro.org> <20150105161412.44f53313e1d771dc9f968264@linux-foundation.org>
In-Reply-To: <20150105161412.44f53313e1d771dc9f968264@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/15 00:14, Andrew Morton wrote:
> On Tue, 23 Dec 2014 18:08:29 +0530 Kiran Raparthy <kiran.kumar@linaro.org> wrote:
> 
>> From: Colin Cross <ccross@android.com>
>>
>> debug: prevent entering debug mode on panic/exception.
>>
>> On non-developer devices, kgdb prevents the device from rebooting
>> after a panic.
>>
>> Incase of panics and exceptions, to allow the device to reboot, prevent
>> entering debug mode to avoid getting stuck waiting for the user to interact
>> with debugger.
>>
>> To avoid entering the debugger on panic/exception without any extra
>> configuration, panic_timeout is being used which can be set via
>> /proc/sys/kernel/panic at run time and CONFIG_PANIC_TIMEOUT sets the default
>> value.
>>
>> ...
>>
> 
> hm.  Why overload the meaning of panic_timeout in this fashion?  If
> someone is using kgdb and has panic_timeout set, they'll get quiet a
> surprise.

Will they?

Setting panic_timeout means the user explicitly requested that the
machine try to perform an unattended reboot after a panic. Wedging in
kgdb during panic on such a system absolutely contradicts the user's
request to have an automated reboot.

In this case it is not overloading the meaning... we are simply altering
kgdb to properly honour the existing meaning.

Changing the behaviour for exceptions as well as for panics *might*
maybe veer into overloading but even there, I think we are simply better
reflecting user intent. It is hard to imagine a user that wants
automatic-reboot-on-panic being happy for the kernel to get stuck
overnight just because of an oops.


> Would it be cleaner/clearer to add some new standalone control for
> this?  One which is only present if CONFIG_KGDB.

I don't think it is clearer (although given it was my review that lead
us here that's probably to be expected).

Separating them out simply means an additional gotcha a user must be
aware of if they want automatic reboot *and* kgdb (i.e. two kernel
cmdline arguments must be used that then just one).


> We appear to have forgotten to document panic_timeout.  Sigh.

On the subject of documentation it would be useful to update the kgdb
docs to document the effect of panic_timeout on panic/exception behaviour.

