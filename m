Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab3CSXur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:50:47 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:53456 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3CSXuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:50:46 -0400
Message-ID: <1363737036.3413.49.camel@thor.lan>
Subject: Re: [PATCH 03/18] tty: Simplify tty buffer/ldisc interface with
 helper function
From: Peter Hurley <peter@hurleysoftware.com>
To: Ilya Zykov <linux@izyk.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Min Zhang <mzhang@mvista.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 19:50:36 -0400
In-Reply-To: <5148E9D2.4030305@izyk.ru>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
	 <1363724513-15604-4-git-send-email-peter@hurleysoftware.com>
	 <5148E9D2.4030305@izyk.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 02:42 +0400, Ilya Zykov wrote:
> On 20.03.2013 0:21, Peter Hurley wrote:
> > Ldisc interface functions must be called with interrupts enabled.
> > Separating the ldisc calls into a helper function simplies the
> > spin lock management.
> > 
> > Update the buffer's read index _after_ the data has been received
> > by the ldisc.
> > 
> 
> Hello Peter!
> It looks good for me.
> I think also we can remove two variables without waste:
> (char_buf), (flag_buf) and use without (&buf->lock)
> (head->char_buf_ptr + head->read), (head->char_buf_ptr + head->read),
> because (head->read) guarded by (TTYP_FLUSHING).

Hi Ilya,
Good to hear from you again.

Yes, I agree, head->read can be safely read and modified here without
owning the buf->lock. And as you correctly point out, there is no need
to make a snapshot of the buf pointers so those locals can be removed.

I'll redo this patch to add both those suggestions. Thanks!

> I have little question about flush_to_ldisc().
> Does can it be multithreaded?
>
> I think yes, because on SMP schedule_work() can work on different CPU paralleled.

Yes, the same work item can now run in parallel on SMP since Tejun Heo
re-did the workqueue implementation on 2.6.36 [Stefan Richter, the
firewire maintainer, recently explained this history to me].

> What do you think about this race condition?
> https://lkml.org/lkml/2011/11/7/98

Yes, that is a possible race condition that could lead to some nasty
results. Good find.

If you want, I could bring that patch into this patchset or you could
re-submit that patch to Greg and I could rebase this patchset on top of
that.

Regards,
Peter Hurley


