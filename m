Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3F0Mo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:44:29 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:38953 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752204Ab3F0Mo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:28 -0400
Message-ID: <51CC33A7.5040901@hurleysoftware.com>
Date: Thu, 27 Jun 2013 08:44:23 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: channing <chao.bi@intel.com>
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: memory leakage in tty_buffer_find()
References: <1372236670.2390.12.camel@bichao>  <51CAE1DD.8070301@hurleysoftware.com> <1372300638.2390.103.camel@bichao>
In-Reply-To: <1372300638.2390.103.camel@bichao>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 10:37 PM, channing wrote:
> On Wed, 2013-06-26 at 08:43 -0400, Peter Hurley wrote:
>> On 06/26/2013 04:51 AM, channing wrote:
>>>
>>> In tty_buffer_find(), it scans all tty buffers in
>>> free buffer queue, if it finds matched one,
>>> tty->buf.free will point to matched one's next buffer,
>>> so tty buffers that ahead of matched one are removed
>>> from free queue, they will never be used but they
>>> are not released, then memory leak happen.
>>
>> Actually, the whole scan loop is wrong: only tty buffers of
>> size 256 are added to the free list.
>>
> Agree that currently all tty buffers of free list are with size
> of 256, but are we sure that the scan loop in tty_buffer_find()
> is wrong and should abandon? From the purpose of tty_buffer_find(),
> I understand it shall scan the free list, but now it doesn't make
> sense because tty_buffer_free() makes all the free list buffers
> with size of 256:
>
> tty_buffer_free()
> {
> 	if (b->size >= 512)
> 		kfree(b);
> }
>
> I don't know why it's 512? looks like a hard configuration?
> Can we make it configurable instead of a fixed value?
>
> I understand, although no memory leak, there is logic mess between
> tty_buffer_find() and tty_buffer_free(), either one shall make
> change to keep accordance?

The approach I took in the 'lockless tty buffers' patchset was to
abandon the scan loop because that precluded the free list being
shared locklessly. My thought is that if, in the future, tty buffers
of sizes other than 256 were to be free-listed, then additional
free-list buckets could be added for the other sizes, thus retaining
the lockless behavior.

