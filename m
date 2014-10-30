Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbaJ3Ayi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:54:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45563 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901AbaJ3Ayg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:54:36 -0400
Date: Wed, 29 Oct 2014 17:54:32 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user <acpi4asus-user@lists.sourceforge.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] eeepc-laptop: don't assume get_acpi succeeds
Message-ID: <20141030005432.GA14609@vmdeb7>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
 <1414005163-3461-9-git-send-email-fransklaver@gmail.com>
 <20141028053429.GI60814@vmdeb7>
 <CAH6sp9PUSbSj0jWNNv6q=rwqUnpkCoiUBxCUAHSVjP+qrUEa9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH6sp9PUSbSj0jWNNv6q=rwqUnpkCoiUBxCUAHSVjP+qrUEa9g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:09:03AM +0100, Frans Klaver wrote:
> On Tue, Oct 28, 2014 at 6:34 AM, Darren Hart <dvhart@infradead.org> wrote:
> > On Wed, Oct 22, 2014 at 09:12:43PM +0200, Frans Klaver wrote:
> >> In eeepc_hotk_thaw, we assume that get_acpi() will effectively return a
> >> bool. However, it is possible that get_acpi() returns an error instead.
> >> We should not be writing error values to the ACPI device, even though
> >> it's quite possible that we couldn't contact the ACPI device in the
> >> first place.
> >>
> >> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> >> ---
> >>  drivers/platform/x86/eeepc-laptop.c | 5 +++--
> >>  1 file changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> >> index 275a239..14f79ef 100644
> >> --- a/drivers/platform/x86/eeepc-laptop.c
> >> +++ b/drivers/platform/x86/eeepc-laptop.c
> >> @@ -911,7 +911,7 @@ static int eeepc_hotk_thaw(struct device *device)
> >>       struct eeepc_laptop *eeepc = dev_get_drvdata(device);
> >>
> >>       if (eeepc->wlan_rfkill) {
> >> -             bool wlan;
> >> +             int wlan;
> >>
> >>               /*
> >>                * Work around bios bug - acpi _PTS turns off the wireless led
> >> @@ -919,7 +919,8 @@ static int eeepc_hotk_thaw(struct device *device)
> >>                * we should kick it ourselves in case hibernation is aborted.
> >>                */
> >>               wlan = get_acpi(eeepc, CM_ASL_WLAN);
> >> -             set_acpi(eeepc, CM_ASL_WLAN, wlan);
> >> +             if (wlan >= 0)
> >> +                     set_acpi(eeepc, CM_ASL_WLAN, wlan);
> >
> > And if not? Seems like we should be passing the error code along.
> 
> Wouldn't that mean that you cannot thaw the system if the wlan acpi call fails?

Good question. I traced it back to the platform driver core, and it just
propogates the error, so I'm not sure either.

> 
> I'd rather have my system up and running without wlan, than I'd have
> my system down because we couldn't start wlan. This is of course
> assuming that returning an error from eeepc_hotk_thaw means the
> thawing stops.

I agree, and this is what it does now, and acer-wmi thaw has similar behavior.

I consider this an incremental improvement, so queued.

-- 
Darren Hart
Intel Open Source Technology Center
