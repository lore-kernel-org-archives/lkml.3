Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3EQSsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:48:04 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:34431 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755923Ab3EQSsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:48:02 -0400
Message-ID: <51967B5D.4080701@hurleysoftware.com>
Date: Fri, 17 May 2013 14:47:57 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: channing <chao.bi@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_buffer: avoid race due to tty_buffer_free_all() being
 misused
References: <1368694762.2911.16.camel@bichao>  <5194D6F9.5000505@hurleysoftware.com> <1368772178.1876.31.camel@bichao>
In-Reply-To: <1368772178.1876.31.camel@bichao>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2013 02:29 AM, channing wrote:
> On Thu, 2013-05-16 at 08:54 -0400, Peter Hurley wrote:
>> On 05/16/2013 04:59 AM, channing wrote:
>>>
>>> In tty_buffer.c, function tty_buffer_free_all() is used to remove
>>> all buffers for a tty, although it's declared that it mustn't be called
>>> when the tty is in use, it cannot guarantee that. we can observe some
>>> device driver make use it by mistake, for example, while tty device is
>>> releasing, the tty data forwarding is not stopped, then it might hit
>>> the case that tty buffer is being used while tty_buffer_free_all()
>>> free this tty buffer, and finally lead to random error at any places,
>>> and it's not clear to debug.
>>
>> What kernel version?
> 3.4
>>
>>> Although device driver could do better, it's simpler and safer to
>>> strengthen protection in the view of tty buffer, by adding a tty->buf.lock
>>> in tty_buffer_free_all() to avoid it racing with ongoing tty buffer
>>> operations.
>>
>> Sorry, but this isn't correct.
>>
>> The driver cannot continue to perform i/o concurrently with
>> tty_port_destroy().
>>
> Thanks for remind, 3.4 haven't tty_port_destroy(), the mainline has
> changed the way to call tty_buffer_free_all().
>
>> If the concurrent use you're observing is with flush_to_ldisc(),
>> that should be fixed in current mainline.
>>
> Yes, when calling flush_to_ldisc() in Kernel 3.4, we could observe the
> tty buffer is corrupted, and dummped stack shows that
> tty_buffer_free_all() was called before. Is it a known issue fixed in
> old version? would you please tell me related patch to solve this
> flush_to_ldisc() issue? Thanks very much.

Hi Chao,

Unfortunately, the fixes for flush_to_ldisc() continuing to
run during, and even after, tty teardown have not been backported
to stable kernels, mostly due to the extensive nature of the fixes.

In fact, even in current mainline and linux-next this problem is
still possible. Hopefully soon the remaining patches will be
reviewed and merged into linux-next.

For your reference, here is a link [1] to the patchset that was
partially accepted for 3.10 (up through 'tty: Fix recursive
deadlock in tty_perform_flush()')

Regards,
Peter Hurley

[1] [PATCH v5 00/44] ldisc patchset
http://www.gossamer-threads.com/lists/linux/kernel/1692114?do=post_view_flat


