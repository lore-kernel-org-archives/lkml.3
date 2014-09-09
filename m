Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbaIIOLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbaIIOLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:11:47 -0400
Date: Tue, 9 Sep 2014 10:11:41 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: check sanity of the incoming report
Message-ID: <20140909141141.GC28906@mail.corp.redhat.com>
References: <1409925435-6556-1-git-send-email-benjamin.tissoires@redhat.com>
 <alpine.LNX.2.00.1409081012160.5523@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1409081012160.5523@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 08 2014 or thereabouts, Jiri Kosina wrote:
> On Fri, 5 Sep 2014, Benjamin Tissoires wrote:
> 
> > In the Dell XPS 13 9333, it appears that sometimes the bus get confused
> > and corrupts the incoming data. It fills the input report with the
> > sentinel value "ff". Synaptics told us that such behavior does not comes
> > from the touchpad itself, so we filter out such reports here.
> > 
> > Unfortunately, we can not simply discard the incoming data because they
> > may contain useful information. Most of the time, the misbehavior is
> > quite near the end of the report, so we can still use the valid part of
> > it.
> > 
> > Fixes:
> > https://bugzilla.redhat.com/show_bug.cgi?id=1123584
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > ---
> >  drivers/hid/hid-rmi.c | 31 ++++++++++++++++++++++++++-----
> >  1 file changed, 26 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> > index 8389e81..db92c3b 100644
> > --- a/drivers/hid/hid-rmi.c
> > +++ b/drivers/hid/hid-rmi.c
> > @@ -320,9 +320,6 @@ static int rmi_f11_input_event(struct hid_device *hdev, u8 irq, u8 *data,
> >  	int offset;
> >  	int i;
> >  
> > -	if (size < hdata->f11.report_size)
> > -		return 0;
> > -
> >  	if (!(irq & hdata->f11.irq_mask))
> >  		return 0;
> >  
> > @@ -332,9 +329,13 @@ static int rmi_f11_input_event(struct hid_device *hdev, u8 irq, u8 *data,
> >  		int fs_bit_position = (i & 0x3) << 1;
> >  		int finger_state = (data[fs_byte_position] >> fs_bit_position) &
> >  					0x03;
> > +		int position = offset + 5 * i;
> > +
> > +		if (position + 5 > size)
> > +			/* partial report, go on with what we received */
> > +			break;
> 
> Do you perhaps want to warn the user here, so that he knows that things 
> are getting a little bit hairy? Or is this happening so often that it 
> makes no sense to warn about it?
> 

I wanted to check on that yesterday, but I have been side tracked quite
a lot. So:
I think there might be too much messages to unconditionally notify the
user here. I do not see a better way than limiting the number to 10 or
so before giving up the notifications. Ideally, I would love to notify
the user when useful information is lost, but I did not came up with a
solution quickly.

On the other hand, not having the coordinates is not that much of a
problem I think. But, missing a f30 message (button event) is much more
of a problem, and I think we should notify the user there unconditionally
because there will be stuck pointers if the failure happens during a
release.

v2 should be on its way something like next week unless somebody else
wants to take over.

Cheers,
Benjamin

