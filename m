Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaKDJLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:11:14 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38423 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKDJLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <20141030233801.GF7996@ZenIV.linux.org.uk>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
	<1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
	<20141030233801.GF7996@ZenIV.linux.org.uk>
Date: Tue, 4 Nov 2014 10:11:09 +0100
Message-ID: <CANq1E4RGrqZxxBi+_Ub_jnwZwQABh92tu-6sPf3Ar8TgzPcP1A@mail.gmail.com>
Subject: Re: How Not To Use kref (was Re: kdbus: add code for buses, domains
 and endpoints)
From: David Herrmann <dh.herrmann@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        Daniel Mack <daniel@zonque.org>,
        Alban Crequy <alban.crequy@collabora.co.uk>,
        javier.martinez@collabora.co.uk, Tom Gundersen <teg@jklm.no>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al

On Fri, Oct 31, 2014 at 12:38 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Oct 29, 2014 at 03:00:52PM -0700, Greg Kroah-Hartman wrote:
>
>> +static void __kdbus_domain_user_free(struct kref *kref)
>> +{
>> +     struct kdbus_domain_user *user =
>> +             container_of(kref, struct kdbus_domain_user, kref);
>> +
>> +     BUG_ON(atomic_read(&user->buses) > 0);
>> +     BUG_ON(atomic_read(&user->connections) > 0);
>> +
>> +     mutex_lock(&user->domain->lock);
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> +     idr_remove(&user->domain->user_idr, user->idr);
>> +     hash_del(&user->hentry);
>         ^^^^^^^^^^^^^^^^^^^^^^^^
>> +     mutex_unlock(&user->domain->lock);
>> +
>> +     kdbus_domain_unref(user->domain);
>> +     kfree(user);
>> +}
>
>> +struct kdbus_domain_user *kdbus_domain_user_unref(struct kdbus_domain_user *u)
>> +{
>> +     if (u)
>> +             kref_put(&u->kref, __kdbus_domain_user_free);
>> +     return NULL;
>> +}
>
> If you remove an object from some search structures, taking the lock in
> destructor is Too Fucking Late(tm).  Somebody might have already found
> that puppy and decided to pick it (all under that lock) just as we'd
> got to that point in destructor and blocked there.  Oops...

Nice catch! I fixed it up via kref_get_unless_zero(). This has the
side-effect that there might be multiple domain_user objects for the
same user, but all but one will have ref==0. They don't carry and
valuable data in those cases, so we're fine. We will just end up using
the next one, or creating a new one.

Thanks a lot!
David
