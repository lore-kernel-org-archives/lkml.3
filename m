Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3D2JVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:21:00 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:41307 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab3D2JU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:20:58 -0400
Subject: Re: [PATCH 1/2] acpi: video: add function to support unregister
 backlight
From: joeyli <jlee@suse.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mjg@redhat.com, rjw@sisk.pl, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Corentin Chary <corentincj@iksaif.net>, Aaron Lu <aaron.lu@intel.com>,
        Thomas Renninger <trenn@suse.de>
In-Reply-To: <20130423041245.GB2435@core.coreip.homeip.net>
References: <1366634355-26482-1-git-send-email-jlee@suse.com>
	 <1366634355-26482-2-git-send-email-jlee@suse.com>
	 <20130423041245.GB2435@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Apr 2013 17:19:27 +0800
Message-ID: <1367227167.22858.42.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, 

Thanks for your review and suggestions first!

於 一，2013-04-22 於 21:12 -0700，Dmitry Torokhov 提到：
> On Mon, Apr 22, 2013 at 08:39:15PM +0800, Chun-Yi Lee wrote:
> > From: "Lee, Chun-Yi" <jlee@suse.com>
> > +static acpi_status
> > +find_video_unregister_backlight(acpi_handle handle, u32 lvl, void *context,
> > +				void **rv)
> > +{
> > +	struct acpi_device *acpi_dev;
> > +	struct acpi_video_bus *video = NULL;
> 
> Gratuitous initialization of local variables prevents compiler from
> warning when you using variable uninitialized.

Yes, I agreed should not put gratuitous initialization, I will remove it
in v2 patch.

> 
> > +	struct acpi_video_device *dev, *next;
> > +
> > +	if (acpi_bus_get_device(handle, &acpi_dev))
> > +		return AE_OK;
> > +
> > +	if (!acpi_match_device_ids(acpi_dev, video_device_ids)) {
> > +		video = acpi_driver_data(acpi_dev);
> > +		acpi_video_bus_stop_devices(video);
> > +		mutex_lock(&video->device_list_lock);
> > +		list_for_each_entry_safe(dev, next, &video->video_device_list,
> > +					entry) {
> > +			if (dev->backlight) {
> > +				backlight_device_unregister(dev->backlight);
> > +				dev->backlight = NULL;
> > +				kfree(dev->brightness->levels);
> > +				kfree(dev->brightness);
> > +			}
> > +		}
> > +		mutex_unlock(&video->device_list_lock);
> > +		acpi_video_bus_start_devices(video);
> > +	}
> > +	return AE_OK;
> > +}
> > +
> > +void acpi_video_backlight_unregister(void)
> > +{
> > +	if (!register_count) {
> 
> Locking? It looks like the rest of the driver ignores locking too...

Did you mean locking video_device_list? 

The acpi/video locks video_device_list when add, remove and notify acpi
video bus driver. It always do the mutex lock before control
video_device_list, so I also add lock when unregister all backlight of
devices.


Thanks a lot!
Joey Lee

