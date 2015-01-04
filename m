Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbbADTpD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 14:45:03 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:48540 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbADTo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 14:44:59 -0500
Message-ID: <54A9982E.7020309@hurleysoftware.com>
Date: Sun, 04 Jan 2015 14:44:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christian Riesch <christian.riesch@omicron.at>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] n_tty: Fix unordered accesses to lockless read buffer
References: <1419941156-5303-1-git-send-email-peter@hurleysoftware.com> <CABkLObqhqE7Y3eD2gUxmqb0etfvYcDYRnE=-i=-4j=4Ea6=F-w@mail.gmail.com>
In-Reply-To: <CABkLObqhqE7Y3eD2gUxmqb0etfvYcDYRnE=-i=-4j=4Ea6=F-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2015 06:00 AM, Christian Riesch wrote:
> Peter,
> 
> Thank you for this patch! Unfortunately I had not much time for this
> since my last patch submission, so I am happy that someone continued
> this work.
> 
> I have a few comments/questions, please see below.
> 
> On Tue, Dec 30, 2014 at 1:05 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> Add commit_head buffer index, which the producer-side publishes
>> after input processing. This ensures the consumer-side observes
>> correctly-ordered writes in raw mode
> 
> I understand that the commit_head reduces the number of memory
> barriers and makes some things easier. But what is so special about
> raw mode that requires the introduction of commit_head?

commit_head is simply the read_head after each received buffer is
processed by the input worker. In this context, I meant 'raw mode' as
any non-canonical mode, ie., any mode in which copy_from_read_buf()
is used by the reader. I'll replace 'raw' with 'non-canonical' instead.

>> (ie., the buffer data is
>> written before the buffer index is advanced).
>>
>> Further, remove read_cnt() and expand inline, using ACCESS_ONCE()
> 
> "ACCESS_ONCE() and memory barriers"?

This portion of the changelog refers only to read_cnt(), for which
memory barriers are not required.

But, while writing the explanatory fragment [1], I realized that
input_available_p() must load the most recent relevant head index
(either canon_head or commit_head based on the mode) because
it may conclude there is no more input _and_ then observe an end-of-file
condition. So I need to fix this up to do the smp_load_acquire() in
input_available_p() and ACCESS_ONCE() in the *_copy_from_read_buf().

Regards,
Peter Hurley

[1]
Strictly speaking, the ACCESS_ONCE()'s are optimizations. Neither the
producer nor consumer require the most recent 'opposed' index; if the
compiler elided the opposed index load, instead reusing an existing load




