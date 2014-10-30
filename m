Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbaJ3IKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:10:25 -0400
Received: from svenfoo.org ([82.94.215.22]:46016 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072AbaJ3IJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:09:42 -0400
Message-ID: <5451F242.4070106@zonque.org>
Date: Thu, 30 Oct 2014 09:09:38 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        Tom Gundersen <teg@jklm.no>
Subject: Re: kdbus: add code to gather metadata
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org> <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
In-Reply-To: <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 11:33 PM, Andy Lutomirski wrote:
> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman

>> +/**
>> + * kdbus_meta_new() - create new metadata object
>> + * @meta:              New metadata object
>> + *
>> + * Return: 0 on success, negative errno on failure.
>> + */
>> +int kdbus_meta_new(struct kdbus_meta **meta)
>> +{
>> +       struct kdbus_meta *m;
>> +
>> +       BUG_ON(*meta);
>> +
>> +       m = kzalloc(sizeof(*m), GFP_KERNEL);
>> +       if (!m)
>> +               return -ENOMEM;
>> +
>> +       /*
>> +        * Remember the PID and user namespaces our credentials belong to;
>> +        * we need to prevent leaking authorization and security-relevant
>> +        * data across different namespaces.
>> +        */
>> +       m->pid_namespace = get_pid_ns(task_active_pid_ns(current));
>> +       m->user_namespace = get_user_ns(current_user_ns());
>> +
> 
> This is unusual, and it could be very expensive (it will serialize
> essentially everyone on an exclusive cacheline).  What attack is it
> protecting against?

As mentioned before, we currently prevent metadata from crossing over
user and pid namespace boundaries. In order to detect such situations,
we need to pin the namespaces of the the task creating such a metadata
object, so we can compare them later, even when the original task is not
alive anymore. But I'm open for cheaper solutions for this, as I'm
admittedly not an expert in these APIs.

>> +static int kdbus_meta_append_cred(struct kdbus_meta *meta)
>> +{
>> +       struct kdbus_creds creds = {
>> +               .uid = from_kuid_munged(current_user_ns(), current_uid()),
>> +               .gid = from_kgid_munged(current_user_ns(), current_gid()),
>> +               .pid = task_pid_vnr(current),
>> +               .tid = task_tgid_vnr(current),
>> +               .starttime = current->start_time,
>> +       };
>> +
>> +       return kdbus_meta_append_data(meta, KDBUS_ITEM_CREDS,
>> +                                     &creds, sizeof(creds));
>> +}
> 
> This seems wrong to me.  Shouldn't this store kuid_t, etc. directly?

The metadata item's memory that is appended here is directly copied into
the final message in the receiver's pool later, so the information has
to be authoritative and translated at this point. This is currently not
a problem as in cases where we cross namespaces, the metadata will not
be added to the final message anyway.

But you're right, if we support translation between namespaces later, we
need to store the kuid_t here, and patch in the the translated version
later, when the message is installed by the receiving peer (which is
when we know which namespace to translate the kuid_t for).

> Also, why pid, tid, and starttime?

Because pid is also part of struct ucred, and starttime seemed to fit in
here as well. After all, an item has some overhead with its header, so
we tried to group information that will most probably be needed
together. Any strong reason not to store it here?


Thanks,
Daniel

