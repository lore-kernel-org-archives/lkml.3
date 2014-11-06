Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaKFVkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:40:41 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64739 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaKFVkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:40:37 -0500
MIME-Version: 1.0
In-Reply-To: <20141106205644.GA31435@kroah.com>
References: <ef53eefc-6310-447e-bc8f-1ff05c0d7b8e@EXC02-ATKLA.omicron.at>
	<20141106203832.GB30170@kroah.com>
	<yw1xwq78jbr6.fsf@unicorn.mansr.com>
	<20141106205644.GA31435@kroah.com>
Date: Thu, 6 Nov 2014 22:40:34 +0100
X-Google-Sender-Auth: zKLFVoNBujr794FGSiwXU03bTpc
Message-ID: <CABkLObqC9uHRydX2LFt=6h6GZYa8JoQYbK9+2gWQ_-wAk5GtXA@mail.gmail.com>
Subject: Re: [PATCH] n_tty: Add memory barrier to fix race condition in
 receive path
From: Christian Riesch <christian.riesch@omicron.at>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 9:56 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Nov 06, 2014 at 08:49:01PM +0000, Måns Rullgård wrote:
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>
>> > On Thu, Nov 06, 2014 at 12:39:59PM +0100, Christian Riesch wrote:
>> >> The current implementation of put_tty_queue() causes a race condition
>> >> when re-arranged by the compiler.
>> >>
>> >> On my build with gcc 4.8.3, cross-compiling for ARM, the line
>> >>
>> >>    *read_buf_addr(ldata, ldata->read_head++) = c;
>> >>
>> >> was re-arranged by the compiler to something like
>> >>
>> >>    x = ldata->read_head
>> >>    ldata->read_head++
>> >>    *read_buf_addr(ldata, x) = c;
>> >>
>> >> which causes a race condition. Invalid data is read if data is read
>> >> before it is actually written to the read buffer.
>> >
>> > Really?  A compiler can rearange things like that and expect things to
>> > actually work?  How is that valid?
>>
>> This is actually required by the C spec.  There is a sequence point
>> before a function call, after the arguments have been evaluated.  Thus
>> all side-effects, such as the post-increment, must be complete before
>> the function is called, just like in the example.
>>
>> There is no "re-arranging" here.  The code is simply wrong.

Oh, I didn't know that, thanks a lot for this!

> Anyway, because of this, no need for the wmb() calls, just rearrange the
> logic and all should be good, right?

I came up with the wmb() stuff after getting scared from reading
Documentation/memory-barriers.txt (which I didn't understand) and
Documentation/circular-buffers.txt (which I understood partly). But it
is actually a circular buffer and circular-buffers.txt says I need
memory barriers for circular buffers. Though I do not know how
function calls fit into this picture.

> Christian, can you test that
> instead?

Sure, but it will probably not happen before Monday. Thanks a lot for your help!

Christian
