Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaCCWz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:55:28 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:52499 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaCCWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:55:26 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
References: <20140303210359.26624.qmail@science.horizon.com>
	<20140303212642.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
Date: Mon, 3 Mar 2014 14:55:25 -0800
X-Google-Sender-Auth: gJiFnSpJob6DsR0iq3J4-9uWjBw
Message-ID: <CA+55aFxszctXek3QCXPeDScdSQZvuzp+EXHdA5cZnG3CLeJ1XA@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 1:52 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>>
>> Most of the cases have it kept separately in registers, actually - there's
>> a reason why fdget() and friends are inlined.
>
> Yes. And bit test and set ops on registers are actually cheaper than
> playing around with bytes.

Ugh. gcc gets this *horribly* wrong when it's a bitfield in a union.

The

    f.need_pos_unlock = 1;

thing *should* be just a simple "orl $2,reg", but bitfields seem to
generate really crappy code, and it actually does some insane shifting
and masking crud with the constant "1".

gcc has had problems with bitfields before.

I think I'll respin this with the compat readv/writev case fixed and
with the bitfield replaced with an "unsigned int" that we just do
bitops by hand on. Because that code generation makes me feel slightly
ill.

              Linus
