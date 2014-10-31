Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbaJaEBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 00:01:38 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:57945 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaJaEBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 00:01:37 -0400
MIME-Version: 1.0
In-Reply-To: <1414699267-17970-1-git-send-email-abrestic@chromium.org>
References: <1414699267-17970-1-git-send-email-abrestic@chromium.org>
Date: Fri, 31 Oct 2014 09:31:36 +0530
Message-ID: <CAJe_ZhdiYd_aBRZeFB+vyM4PtXq=5RqqtAfwZbz0kb71XP==Jg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mailbox: Avoid NULL-pointer dereference in mbox_chan_received_data()
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 October 2014 01:31, Andrew Bresticker <abrestic@chromium.org> wrote:
> If a message has been received on a channel, but no client has yet bound
> to it, mbox_chan_received_data() will dereference a NULL client pointer.
> Check for the presence of a client first.
>
Let me quote from the documentation of the API ....
/**
   ....
 * After startup and before shutdown any data received on the chan
 * is passed on to the API via atomic mbox_chan_received_data().
 * The controller should ACK the RX only after this call returns.
 */
Please note "after startup and before shutdown".

We can sure suppress the crash by returning from
mbox_chan_received_data() but would that be neat? Because the real
problem lies with the controller driver that pushes data even from a
mailbox that nobody has 'enabled'.  I can see your virtual-channel
implementation needs to maintain a field for each such channel, but
for physically discreet channels it would usually be a simple matter
of setting/clearing a bit (IRQ Enable/Disable).

However, I think even for your case, you could simply set/clear the
'con_priv' instead of 'vchan_allocated' and use that hint whether to
push RX data up to the core or not.

Thanks
Jassi
