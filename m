Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbaGYMD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:03:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32971 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbaGYMDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:03:25 -0400
Date: Fri, 25 Jul 2014 20:00:39 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Jean Delvare <jdelvare@suse.de>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c: pca954x: put the mux to disconnected state after
 resume
Message-ID: <20140725200039.75f38052@xhacker>
In-Reply-To: <20140725091519.4e780494@endymion.delvare>
References: <1406254559-5615-1-git-send-email-jszhang@marvell.com>
	<20140725091519.4e780494@endymion.delvare>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-25_04:2014-07-25,2014-07-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1407250139
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Fri, 25 Jul 2014 00:15:19 -0700
Jean Delvare <jdelvare@suse.de> wrote:

> Hi Jisheng Zhang,
> 
> On Fri, 25 Jul 2014 10:15:59 +0800, Jisheng Zhang wrote:
> > pca954x may be power lost during suspend, so after resume we also suffer
> > the issue fixed by commit cd823db8b1161ef0d756514d280715a576d65cc3,
> > 
> >  "pca954x power-on default is channel 0 connected. If multiple pca954x
> >  muxes are connected to the same physical I2C bus, the parent bus will
> >  see channel 0 devices behind both muxes by default."
> > 
> > What's more, when resume bootloader may also operate the mux, so the
> > the channel connected after that may not be the one driver thought.
> > 
> > We fix this problem by putting the mux to disconnected state and
> > clearing last_chan in the resume hook.
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> > ---
> >  drivers/i2c/muxes/i2c-mux-pca954x.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c
> > b/drivers/i2c/muxes/i2c-mux-pca954x.c index 9bd4212..c8c3d58 100644
> > --- a/drivers/i2c/muxes/i2c-mux-pca954x.c
> > +++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
> > @@ -273,9 +273,23 @@ static int pca954x_remove(struct i2c_client *client)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_PM_SLEEP
> > +static int pca954x_resume(struct device *dev)
> > +{
> > +	struct i2c_client *client = to_i2c_client(dev);
> > +	struct pca954x *data = i2c_get_clientdata(client);
> > +
> > +	data->last_chan = 0;
> > +	return i2c_smbus_write_byte(client, 0);
> > +}
> > +#endif
> > +
> > +static SIMPLE_DEV_PM_OPS(pca954x_pm, NULL, pca954x_resume);
> 
> I think you must include <linux/pm.h> for this.
> 
> Other than this, the change looks reasonable, you can add:
> 
> Reviewed-by: Jean Delvare <jdelvare@suse.de>
> 
> (Please note my new e-mail address.)


Thanks for reviewing. I have cooked patch v2.

Thanks very much,
Jisheng
