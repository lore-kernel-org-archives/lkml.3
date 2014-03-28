Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaC1Teu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 15:34:50 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51912 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaC1Tes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 15:34:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140328.145410.1817326821928803131.davem@davemloft.net>
References: <1395839117-20090-1-git-send-email-dh.herrmann@gmail.com>
	<20140328.145410.1817326821928803131.davem@davemloft.net>
Date: Fri, 28 Mar 2014 20:34:47 +0100
Message-ID: <CANq1E4TxaNnZoqfw5DiifAhk28hVq5HJJMd07ZDFAjdc68nKKg@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Provide netdev naming-policy via sysfs
From: David Herrmann <dh.herrmann@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, Tom Gundersen <teg@jklm.no>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Mar 28, 2014 at 7:54 PM, David Miller <davem@davemloft.net> wrote:
> udev can look at the device type, and policies can be defined that key
> off of that device type, entirely in userspace.

Regarding wifi-P2P devices, udev can indeed use nl80211 to get the
exact IF-type. An attribute would be much easier to read out, but I'm
ok if we don't want to replicate that information.

However, as mentioned in the discussions on v1, there're more
use-cases than that. Imagine a 3rd party initrd renames a
network-device early, if udev runs in the main system, we would rename
the device again. If we could detect the rename via NET_NAME_RENAMED,
we wouldn't break such setups. The only reason to rename devices in
udev is to get reliable names. If someone else already renamed a
device, we always expect them to provide better names than we do, so
udev should only touch devices that have kernel-enumerated names.
Of course, this can be fixed by requiring all the initrd developers to
somehow tag devices as already renamed. But this would replicate
information that the kernel already has.

Another example are dynamically created devices via RTM_NEWLINK. The
if-names are provided by user-space and udev should never try to do
any magic renaming on them (why would we? you can just easily fix the
code that created the device).

So it turns out, all we want to know is whether an interface-name was
chosen by the kernel via plain, simple enumeration, or whether it has
a user-space origin. Only in the former case we want to rename the
device. The name_assign_type attribute tells us exactly where a name
comes from and thus avoids maintaining blacklists in user-space that
skip renaming on such devices. I'm sorry, but I cannot see why such
blacklists (or whitelists) are preferred over a sysfs attribute.

Thanks
David
