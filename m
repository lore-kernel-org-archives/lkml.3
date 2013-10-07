Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3JGXlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:41:17 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33083 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3JGXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:41:11 -0400
Message-ID: <52534692.7010400@linaro.org>
Date: Mon, 07 Oct 2013 16:41:06 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: LKML <linux-kernel@vger.kernel.org>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dhaval.giani@gmail.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, Rob Clark <robdclark@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 05/14] vrange: Add new vrange(2) system call
References: <1380761503-14509-1-git-send-email-john.stultz@linaro.org> <1380761503-14509-6-git-send-email-john.stultz@linaro.org> <52533C12.9090007@zytor.com> <5253404D.2030503@linaro.org> <52534331.2060402@zytor.com>
In-Reply-To: <52534331.2060402@zytor.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 04:26 PM, H. Peter Anvin wrote:
> On 10/07/2013 04:14 PM, John Stultz wrote:
>>> I see from the change history of the patch that this was an madvise() at
>>> some point, but was changed into a separate system call at some point,
>>> does anyone remember why that was?  A quick look through my LKML
>>> archives doesn't really make it clear.
>> The reason we can't use madvise, is that to properly handle error cases
>> and report the pruge state, we need an extra argument.
>>
>> In much earlier versions, we just returned an error when setting
>> NONVOLATILE if the data was purged. However, since we have to possibly
>> do allocations when marking a range as non-volatile, we needed a way to
>> properly handle that allocation failing. We can't just return ENOMEM, as
>> we may have already marked purged memory as non-volatile.
>>
>> Thus, that's why with vrange, we return the number of bytes modified,
>> along with the purge state. That way, if an error does occur we can
>> return the purge state of the bytes successfully modified, and only
>> return an error if nothing was changed, much like when a write fails.
>>
> I am not clear at all what the "purge state" is in this case.


You mark a chunk of memory as volatile, then at some point later, mark
its as non-volatile. The purge state tells you if the memory is still
there, or if we threw it out due to memory pressure. This lets the
application regnerate the purged data before continuing on.

thanks
-john

