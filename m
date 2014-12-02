Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174AbaLBMO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:14:29 -0500
Received: from h1.radempa.de ([176.9.142.194]:44378 "EHLO mail.cosmopool.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149AbaLBMO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:14:26 -0500
From: Harald Geyer <harald@ccbib.org>
To: Richard Weinberger <richard@nod.at>
cc: jic23@kernel.org, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net,
        sanjeev_sharma@mentor.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] iio: dht11: Add locking
In-reply-to: <547D99DE.6030309@nod.at>
References: <1417465651-16036-1-git-send-email-richard@nod.at> <E1XvkMu-000137-KP@stardust.g4.wien.funkfeuer.at> <547D99DE.6030309@nod.at>
Comments: In-reply-to Richard Weinberger <richard@nod.at>
   message dated "Tue, 02 Dec 2014 11:52:14 +0100."
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4553.1417522442.1@stardust.g4.wien.funkfeuer.at>
Date: Tue, 02 Dec 2014 13:14:02 +0100
Message-Id: <E1XvmLC-0001BT-F3@stardust.g4.wien.funkfeuer.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger writes:
> Harald,
> 
> Am 02.12.2014 um 11:07 schrieb Harald Geyer:
> > Hi Richard,
> > 
> > thanks for the patch. Comments inline.
> > 
> > Richard Weinberger writes:
> >> Protect the read function from concurrent reads.
> >>
> >> Signed-off-by: Richard Weinberger <richard@nod.at>
> >> ---
> >>  drivers/iio/humidity/dht11.c | 19 ++++++++++++++-----
> >>  1 file changed, 14 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/iio/humidity/dht11.c b/drivers/iio/humidity/dht11.c
> >> index 623c145..7636e66 100644
> >> --- a/drivers/iio/humidity/dht11.c
> >> +++ b/drivers/iio/humidity/dht11.c
> > 
> > #include <linux/mutex.h>
> > 
> >> @@ -57,6 +57,7 @@ struct dht11 {
> >>  	int				irq;
> >>  
> >>  	struct completion		completion;
> >> +	struct mutex			lock;
> >>  
> >>  	s64				timestamp;
> >>  	int				temperature;
> >> @@ -146,16 +147,17 @@ static int dht11_read_raw(struct iio_dev *iio_dev,
> >>  	int ret;
> >>  
> >>  	if (dht11->timestamp + DHT11_DATA_VALID_TIME < iio_get_time_ns()) {
> >> +		mutex_lock(&dht11->lock);
> > 
> > Move the locking out of the if statement.
> 
> Care to explain why?

The purpose of the if statement is to limit the number of data
transmissions if values are requested multiple times in short
succession. (Ie an application reading both sensor values.)

If we have concurrent reads, then the later one will wait in the
mutex_lock() while the former will update the timestamp. If the
later one resumes, it won't check the timestamp and cause an
unnecessary data transmission.
 
> But I found another issue in my patch.
> The "dht11->num_edges = -1;" before "return ret" needs to go into the locked area.
> Will send an updated version soon.
> 
> > BTW, it seems that there is already locking around read_raw() in the
> > in-kernel consumer interface but not in the sysfs interface. Is there
> > any reason for this difference?
> 
> Dunno. :-)

If locking is actually necessary, then this would be a bug in the
current version of the driver, which wasn't caught by at least three
people doing reviews, so maybe let's find out if it really is necessary
or if I'm missing something ...

Harald
