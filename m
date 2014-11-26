Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaKZIsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:48:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13622 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaKZIsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:48:20 -0500
X-AuditID: cbfee61a-f79c06d000004e71-ab-547593d2b85a
Date: Wed, 26 Nov 2014 09:47:33 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: Re: [PATCH v2 4/4] thermal: of: Extend current of-thermal.c code to
 allow setting emulated temp
Message-id: <20141126094733.683a4099@amdc2363>
In-reply-to: <20141125204401.GC14292@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-5-git-send-email-l.majewski@samsung.com>
 <20141125204401.GC14292@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jQd1Lk0tDDD6c57F4vGYxk8XGGetZ
	Lb587mOzmH/lGqvFmr9KFm8ecVtc3jWHzeJz7xFGiycLzzBZPLg6jc3iyUOgqlcH21gsfu6a
	x+LA67Fz1l12j8V7XjJ5rJv2ltmjt/kdm8ffWftZPHZ+b2D36NuyitHj8yY5j41zQwM4o7hs
	UlJzMstSi/TtErgynl3fzFjwUrLiyoFJbA2Mq0W6GDk5JARMJP7fWMAIYYtJXLi3nq2LkYtD
	SGA6o0Rf40UWCOcXo0Tr7GtAGQ4OFgFViSeH9UAa2AT0JD7ffcoEYosIaEmcuLQdzGYW+MMs
	cXMFE0i5sECWROsmc5AwL1D5iYVN7CA2p4C+xImPT5ghxj9klLh2+wvYEfwCkhLt/34wQxxk
	J3Hu0wZ2iGZBiR+T77FAzNeS2LytiRXClpfYvOYt8wRGwVlIymYhKZuFpGwBI/MqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjODYeia1g3Flg8UhRgEORiUe3gip0hAh1sSy4srcQ4wSHMxK
	IrwmdUAh3pTEyqrUovz4otKc1OJDjNIcLErivDdu5oYICaQnlqRmp6YWpBbBZJk4OKUaGIO+
	O5i0cxgFTC58vuPVUSu5rg/Pnqypq97I6JEyf8clibQlG+0SmSZfXcP3JcqQhe3871O33f/U
	/DBZZyBtzlIpZHnqxkqbENM3S58YRn3wvtcSEHeOQdJ8xn2hG5u07h/emXfdfrnqZs+l9wsE
	nm2K/qyoG7vbvqyXX2Xm0je8z2du2ZUazafEUpyRaKjFXFScCADUmCSeqQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> On Thu, Nov 20, 2014 at 05:21:28PM +0100, Lukasz Majewski wrote:
> > Before this change it was only possible to set get_temp() and
> > get_trend() methods to be used in the common code handling passing
> > parameters via device tree to "cpu-thermal" CPU thermal zone device.
> > 
> > Now it is possible to also set emulated value of temperature for
> > debug purposes.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> > Changes for v2:
> > - Rework the emulated temperature setting code to use
> > of_thermal_sensor_ops structure
> > ---
> >  drivers/thermal/of-thermal.c | 24 ++++++++++++++++++++++++
> >  include/linux/thermal.h      |  1 +
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/drivers/thermal/of-thermal.c
> > b/drivers/thermal/of-thermal.c index 33921c5..ad7dc2b 100644
> > --- a/drivers/thermal/of-thermal.c
> > +++ b/drivers/thermal/of-thermal.c
> > @@ -174,6 +174,28 @@ of_thermal_get_trip_points(struct
> > thermal_zone_device *tz) return data->gtrips;
> >  }
> >  
> > +/**
> > + * of_thermal_set_emul_temp - function to set emulated temperature
> > + *
> > + * @tz:	pointer to a thermal zone
> > + * @temp:	temperature to set
> > + *
> > + * This function gives the ability to set emulated value of
> > temperature,
> > + * which is handy for debugging
> > + *
> > + * Return: zero on success, error code otherwise
> > + */
> > +static int of_thermal_set_emul_temp(struct thermal_zone_device *tz,
> > +				    unsigned long temp)
> > +{
> > +	struct __thermal_zone *data = tz->devdata;
> > +
> > +	if (!data->ops || !data->ops->set_emul_temp)
> > +		return -EINVAL;
> > +
> > +	return data->ops->set_emul_temp(data->sensor_data, temp);
> > +}
> > +
> >  static int of_thermal_get_trend(struct thermal_zone_device *tz,
> > int trip, enum thermal_trend *trend)
> >  {
> > @@ -405,6 +427,7 @@ thermal_zone_of_add_sensor(struct device_node
> > *zone, 
> >  	tzd->ops->get_temp = of_thermal_get_temp;
> >  	tzd->ops->get_trend = of_thermal_get_trend;
> > +	tzd->ops->set_emul_temp = of_thermal_set_emul_temp;
> >  	mutex_unlock(&tzd->lock);
> >  
> >  	return tzd;
> > @@ -533,6 +556,7 @@ void thermal_zone_of_sensor_unregister(struct
> > device *dev, mutex_lock(&tzd->lock);
> >  	tzd->ops->get_temp = NULL;
> >  	tzd->ops->get_trend = NULL;
> > +	tzd->ops->set_emul_temp = NULL;
> >  
> >  	tz->ops = NULL;
> >  	tz->sensor_data = NULL;
> > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > index 88d7249..5eb9d44 100644
> > --- a/include/linux/thermal.h
> > +++ b/include/linux/thermal.h
> > @@ -301,6 +301,7 @@ struct thermal_genl_event {
> >  struct thermal_zone_of_device_ops {
> >  	int (*get_temp)(void *, long *);
> >  	int (*get_trend)(void *, long *);
> > +	int (*set_emul_temp)(void *, unsigned long);
> 
> Please add it in the list of Optional functions in the comment above
> this struct.

I will add proper comment to struct thermal_zone_of_device_ops comment.

> 
> Apart from that:
> 
> 
> Acked-by: Eduardo Valentin <edubezval@gmail.com>
> 
> 
> >  };
> >  
> >  /**
> > -- 
> > 2.0.0.rc2
> > 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
