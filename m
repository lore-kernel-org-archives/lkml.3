Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbaIDQIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:08:22 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42668 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228AbaIDQIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:08:19 -0400
Message-ID: <54088E6C.2020209@hurleysoftware.com>
Date: Thu, 04 Sep 2014 12:08:12 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/26] tty: Convert tty_struct bitfield to bools
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com> <1409693975-1028-22-git-send-email-peter@hurleysoftware.com> <20140903115852.5a720754@alan.etchedpixels.co.uk> <54070643.9080903@hurleysoftware.com> <20140903131919.0d970b6f@alan.etchedpixels.co.uk> <54072F75.70107@hurleysoftware.com> <20140903175606.GA9740@kroah.com>
In-Reply-To: <20140903175606.GA9740@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 01:56 PM, Greg Kroah-Hartman wrote:
> On Wed, Sep 03, 2014 at 11:10:45AM -0400, Peter Hurley wrote:
>> On 09/03/2014 08:19 AM, One Thousand Gnomes wrote:
>>>> Ahh. Thanks for the insight, Alan.
>>>>
>>>> But set_bit() et. al. will generate an incredible amount of churn;
>>>> what if I split the fields up to prevent false-sharing?
>>>
>>> Do you feel lucky ;-)
>>
>> Hahaha  :)
>>
>>> I'd rather set_bit and friends were used. They exist largely for this
>>> kind of reason and they also have atomic test/set methods which may in
>>> the longer term be very useful.
>>>
>>> Yes it is churn can't argue with that.
>>
>> Yuck. There should be a better way. IXANY mode is suddenly going to
>> have a ton of unnecessary bus locks on x86.
> 
> True, but at least it will be correct, which I'm guessing today it isn't
> :(
> 
>> Note the ctrl_status field is a byte as well, which can't be RMW'ed by
>> the bit-locked primitives, and definitely should not be aggregated with
>> any adjacent field.
> 
> Never trust what an ia64 compiler can, and will, do...

I could not get the ia64 compiler to merge adjacent reads or writes on
bools or chars, at all.

However, Alan's point applies anyway --
because the Alpha is not byte-addressable.

This means that smaller-than-int storage is _always_ read-modify-write.

So my plan is now to take this patch out of this series and submit
a new series on top of this one that will:
1) merge the ctrl_status field and packet field into an int size, which
   will guarantee atomicity to those fields on all arches when accessed
   holding the ->ctrl_lock.
2) make tty->hw_stopped an int. This way legacy drivers -- synclink,
   cyclades, nozomi, isdn4linux, et. al. -- will not need changes.
   UART drivers should use uport->hw_stopped (added in this series).
   New, non-UART drivers should use their own hw_stopped mechanism.
3) keep tty->stopped and tty->flow_stopped as bitfield members of the
   same bitfield, but size that bitfield to unsigned long [note 1 below].
   This should guarantee atomicity on all arches when accessed while
   holding the ->flow_lock, without requiring further code changes and
   without impacting other arches.

Regards,
Peter Hurley

[Note 1] gcc pre-4.7.2 corrupts data adjacent to a smaller-than-8-byte
bitfield on sparc64, ia64, ppc64 and alpha.


