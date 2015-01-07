Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbbAGQjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:39:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30268 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAGQjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:39:46 -0500
Message-ID: <54AD6148.6030703@oracle.com>
Date: Wed, 07 Jan 2015 11:39:36 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] firmware class: remove from pending list on load failure
References: <1420472494-25836-1-git-send-email-sasha.levin@oracle.com> <CACVXFVPUF1x8YDwHtYzoC6LiPy22Lr2bZC-N73+NakFMBrEUFw@mail.gmail.com>
In-Reply-To: <CACVXFVPUF1x8YDwHtYzoC6LiPy22Lr2bZC-N73+NakFMBrEUFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 11:52 PM, Ming Lei wrote:
> On Mon, Jan 5, 2015 at 11:41 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> > If we failed loading the firmware we have to make sure it leaves the pending
>> > list if abort wasn't executed for it.
>> >
>> > Otherwise we'd free an object still on the pending list and corrupt it.
>> >
>> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> > ---
>> >  drivers/base/firmware_class.c | 11 ++++++++++-
>> >  1 file changed, 10 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>> > index 58470c3..8ccf6cf4 100644
>> > --- a/drivers/base/firmware_class.c
>> > +++ b/drivers/base/firmware_class.c
>> > @@ -929,9 +929,18 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
>> >         cancel_delayed_work_sync(&fw_priv->timeout_work);
>> >         if (is_fw_load_aborted(buf))
>> >                 retval = -EAGAIN;
>> > -       else if (!buf->data)
>> > +       else if (!buf->data) {
>> >                 retval = -ENOMEM;
>> >
>> > +               /*
>> > +                * We failed loading, but abort was never done so we
>> > +                * need to remove it from the pending list ourselves.
>> > +                */
>> > +               mutex_lock(&fw_lock);
>> > +               list_del_init(&buf->pending_list);
>> > +               mutex_unlock(&fw_lock);
> The buf is always removed before the complete_all(), isn't it? Or did
> you observe the issue?

Not in the case where userspacehelper fails. Yes, this is not a theoretical
thing and can be easily reproduced.


Thanks,
Sasha
