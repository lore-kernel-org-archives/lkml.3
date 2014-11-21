Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbaKUBVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:21:03 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:47331 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536AbaKUBVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:21:00 -0500
MIME-Version: 1.0
In-Reply-To: <20141120101505.GA791@pd.tnic>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
	<20141119102954.GA5617@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
	<20141120101505.GA791@pd.tnic>
Date: Fri, 21 Nov 2014 09:20:59 +0800
Message-ID: <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
From: rui wang <ruiv.wang@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/14, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Nov 19, 2014 at 11:34:10PM +0000, Luck, Tony wrote:
>> The SDM has this to say about EN=0 (in section 15.10.4.1 of volume 3B):
>>
>>    When the EN flag is zero but the VAL and UC flags are one in
>>    the IA32_MCi_STATUS register, the reported uncorrected error
>>    in this bank is not enabled. As uncorrected errors with the
>>    EN flag = 0 are not the source of machine check exceptions,
>>    the MCE handler should log and clear non-enabled errors when
>>    the S bit is set and should continue searching for enabled
>>    errors from the other IA32_MCi_STATUS registers. Note that
>>    when IA32_MCG_CAP [24] is 0, any uncorrected error condition
>>    (VAL =1 and UC=1) including the one with the EN flag cleared
>>    are fatal and the handler must signal the operating system to
>>    reset the system. For the errors that do not generate machine
>>    check exceptions, the EN flag has no meaning.
>>
>> Note the "should log and clear".  We just clear ... just need to shuffle
>> some code
>> in mce.c to add the logging.
>
> Sure, we can log those.
>
>> But we still need something like Rui's patch - calling mcelog()
>> doesn't ensure that we see something on the console about possible
>> cause of the problem.
>
> So you're saying we should drain the mcelog buffer to the console in
> such situations before we panic? If so, there's drain_mcelog_buffer()
> which could be changed to call print_mce() instead of going to the
> x86_mce_decoder_chain.
>

Hi Boris,

We've found there are cases after mce_log() has been called, we then
decide to panic, but print_mce() can't find anything in the mcelog
buffer. I think the mcelog buffer can be consumed by the user space
daemon (possibly on a different CPU). We may end up seeing the "panic
from unknown source" message without printing any mca banks, which is
one of the cases where this bug was originated.

The current logging mechanism is not as reliable as it looks. When
some log entries have been copied to user space, but haven't been
logged on the disk, and we panic, then we permanently lose those log
entries.

Thanks
Rui
