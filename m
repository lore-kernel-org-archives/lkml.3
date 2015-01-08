Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbbAHCPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:15:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbAHCPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:15:51 -0500
MIME-Version: 1.0
In-Reply-To: <54AD6148.6030703@oracle.com>
References: <1420472494-25836-1-git-send-email-sasha.levin@oracle.com>
	<CACVXFVPUF1x8YDwHtYzoC6LiPy22Lr2bZC-N73+NakFMBrEUFw@mail.gmail.com>
	<54AD6148.6030703@oracle.com>
Date: Thu, 8 Jan 2015 10:15:48 +0800
Message-ID: <CACVXFVMcggxG41c5h4-3dY_twZfD3artiD8G=x608ADnNfnn4Q@mail.gmail.com>
Subject: Re: [PATCH] firmware class: remove from pending list on load failure
From: Ming Lei <ming.lei@canonical.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2015 at 12:39 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 01/06/2015 11:52 PM, Ming Lei wrote:
>> On Mon, Jan 5, 2015 at 11:41 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>> > If we failed loading the firmware we have to make sure it leaves the pending
>>> > list if abort wasn't executed for it.
>>> >
>>> > Otherwise we'd free an object still on the pending list and corrupt it.
>>> >
>>> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>>> > ---
>>> >  drivers/base/firmware_class.c | 11 ++++++++++-
>>> >  1 file changed, 10 insertions(+), 1 deletion(-)
>>> >
>>> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
>>> > index 58470c3..8ccf6cf4 100644
>>> > --- a/drivers/base/firmware_class.c
>>> > +++ b/drivers/base/firmware_class.c
>>> > @@ -929,9 +929,18 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
>>> >         cancel_delayed_work_sync(&fw_priv->timeout_work);
>>> >         if (is_fw_load_aborted(buf))
>>> >                 retval = -EAGAIN;
>>> > -       else if (!buf->data)
>>> > +       else if (!buf->data) {
>>> >                 retval = -ENOMEM;
>>> >
>>> > +               /*
>>> > +                * We failed loading, but abort was never done so we
>>> > +                * need to remove it from the pending list ourselves.
>>> > +                */
>>> > +               mutex_lock(&fw_lock);
>>> > +               list_del_init(&buf->pending_list);
>>> > +               mutex_unlock(&fw_lock);
>> The buf is always removed before the complete_all(), isn't it? Or did
>> you observe the issue?
>
> Not in the case where userspacehelper fails. Yes, this is not a theoretical
> thing and can be easily reproduced.

OK, I am just curious how it is triggered.

One situation I thought of is that the request context is interrupted
by signal after wait_for_completion() becomes interruptable, and the
fix should abort the request if retval is -ERESTARTSYS.

Or could you share how to reproduce if it isn't above case?

Thanks,
Ming Lei
