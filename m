Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaGJQY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:24:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58890 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbaGJQY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:24:28 -0400
Date: Thu, 10 Jul 2014 18:24:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 3/6] x86-mce: Clear CMCI enable on all claimed CMCI banks
 before reboot.
Message-ID: <20140710162419.GK2970@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-4-git-send-email-hskinnemoen@google.com>
 <3908561D78D1C84285E8C5FCA982C28F32857499@ORSMSX114.amr.corp.intel.com>
 <CAFQmdRYabFy84FxeJGbrdd6w5O0mu9Kn_jE5V4rpw7cBrMvb0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRYabFy84FxeJGbrdd6w5O0mu9Kn_jE5V4rpw7cBrMvb0w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:40:55PM -0700, Havard Skinnemoen wrote:
> On Wed, Jul 9, 2014 at 1:36 PM, Luck, Tony <tony.luck@intel.com> wrote:
> > +       if (!xchg(&reboot_notifier_registered, true))
> > +               register_reboot_notifier(&cmci_reboot_notifier);
> >
> > This is super-safe ... but isn't the xchg() overkill? I thought we serialized bringup
> > of other cpus.
> 
> Could be. There are spinlocks being taken elsewhere in that path
> though, and I'm not sure if I see any downside with the xchg(), unless
> this path is actually performance-critical.

Several things:

We don't need all that atomicity special fun if we register the reboot
notifier on the BSP, say from mcheck_init() which is done even pre-SMP.

If that's too early, we can add an initcall or whatever...

Also, since this is kexec-only, this all should be nicely enabled only
on KEXEC kernels. Please use the ifdeffery sparingly :-)

I'm saying that because I'm assuming BIOS will clear those MSRs upon
warm reset. If it doesn't, then we have a bigger problem.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
