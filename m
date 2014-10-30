Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaJ3D4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 23:56:23 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:50016 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaJ3D4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 23:56:22 -0400
MIME-Version: 1.0
In-Reply-To: <87k33iw759.fsf@x220.int.ebiederm.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-6-git-send-email-gregkh@linuxfoundation.org> <87k33iw759.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 20:55:58 -0700
Message-ID: <CALCETrXm116+eRvYY7QNbHcrOpZYOCqvC_WPguPZm-G+UEHeGw@mail.gmail.com>
Subject: Re: kdbus: add connection, queue handling and message validation code
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        alban.crequy@collabora.co.uk,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 8:47 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>
>> From: Daniel Mack <daniel@zonque.org>
>>
>> This patch adds code to create and destroy connections, to validate
>> incoming messages and to maintain the queue of messages that are
>> associated with a connection.
>>
>> Note that connection and queue have a 1:1 relation, the code is only
>> split in two parts for cleaner separation and better readability.
>
> You are not performing capability checks at open time.
>
> As such this API is suceptible to a host of file descriptor passing attacks.

To be fair, write(2) doesn't work on these fds, so the usual attacks
don't work.  But who knows what absurd things kdbus clients will do
with fd passing?

--Andy

>
>> Signed-off-by: Daniel Mack <daniel@zonque.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>
>> +/*
>> + * Check for maximum number of messages per individual user. This
>> + * should prevent a single user from being able to fill the receiver's
>> + * queue.
>> + */
>> +static int kdbus_conn_queue_user_quota(struct kdbus_conn *conn,
>> +                                    const struct kdbus_conn *conn_src,
>> +                                    struct kdbus_queue_entry *entry)
>> +{
>> +     unsigned int user;
>> +
>> +     if (!conn_src)
>> +             return 0;
>> +
>> +     if (ns_capable(&init_user_ns, CAP_IPC_OWNER))
>> +             return 0;
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
