Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3CKXhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:37:45 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40709 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3CKXhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:37:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130309071037.GA13360@dcvr.yhbt.net>
References: <20130307112639.GA25130@dcvr.yhbt.net>
	<20130308013027.GA31830@dcvr.yhbt.net>
	<CAMP5Xgdsam2DGLshL5Uu5Q4La_nAq=u1YRNBwAxDstgCvJiqfw@mail.gmail.com>
	<20130308204944.GA27379@dcvr.yhbt.net>
	<CAMP5Xgc4-oX=-V57Mu5PARCWdfpkjck0VnZNAXH-JisvKi5tAg@mail.gmail.com>
	<20130309071037.GA13360@dcvr.yhbt.net>
Date: Mon, 11 Mar 2013 16:37:42 -0700
Message-ID: <CAMP5Xgdy9hJE1JCHYN2iK9W3UQvmgBGHH_9Jy2-mQyNxkHGwTQ@mail.gmail.com>
Subject: Re: epoll: possible bug from wakeup_source activation
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 11:10 PM, Eric Wong <normalperson@yhbt.net> wrote:
> Arve Hjønnevåg <arve@android.com> wrote:
>> On Fri, Mar 8, 2013 at 12:49 PM, Eric Wong <normalperson@yhbt.net> wrote:
>> > What happens if ep_modify calls ep_destroy_wakeup_source
>> > while __pm_stay_awake is running on the same epi->ws?
>>
>> Yes, that looks like a problem. I think calling
>> ep_destroy_wakeup_source with ep->lock held should fix that. It is not
>> clear how useful changing EPOLLWAKEUP in ep_modify is, so
>> alternatively we could remove that feature and instead only allow it
>> to be set in ep_insert.
>
> ep->lock would work, but ep->lock is already a source of heavy
> contention in my multithreaded+epoll webservers.
>

This should not have any significant impact on that since you would be
adding a lock to a code path that is, as far as I know, unused.

> Perhaps RCU can be used?  I've no experience with RCU, but I've been
> meaning to get acquainted with RCU.
>

That adds code to the common path however. The wakeup_source is not
touch without holding one of the locks so holding both locks before
deleting it seems like a simpler solution.

> Another possible solution is to only use ep->ws and add an atomic
> counter to ep; so __pm_relax(ep->ws) is only called when the atomic
> counter reaches zero.

-- 
Arve Hjønnevåg
