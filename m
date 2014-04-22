Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaDVIlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:41:42 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44469 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaDVIli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:41:38 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-fc-53562b3f7b58
Message-id: <1398156094.6077.4.camel@AMDC1943>
Subject: Re: [PATCH 1/2] mfd: sec-core: Remove duplicated device type from
 sec_pmic
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Tue, 22 Apr 2014 10:41:34 +0200
In-reply-to: <20140422080939.GE17657@lee--X1>
References: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
 <20140417082628.GG28725@lee--X1> <1397807684.29800.8.camel@AMDC1943>
 <20140422080939.GE17657@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xK7r22mHBBs/+GllsnLGe1eJs0xt2
	i/tfjzJaXN41h81i7ZG77Banu1ktLq74wuTA7nHn2h42j3knAz36tqxi9Pi8SS6AJYrLJiU1
	J7MstUjfLoEr48D5JUwFt3krFn2cxdTAeJmri5GTQ0LARGLi9lZWCFtM4sK99WxdjFwcQgJL
	GSX2XV3EDOF8ZpTYcb6ZBaSKV0BP4tn2DewgtrBAqETL3P1gNpuAscTm5UuAujk4RARUJM69
	MQfpZRb4xyixZOJZZpA4i4CqxMNT0iAmp4CuxNS9aRDjNzJKTG+6wgYyhllAXWLSPJC9IAcp
	S8zbf4wJYq2gxI/J91ggauQlNq95yzyBUWAWkpZZSMpmISlbwMi8ilE0tTS5oDgpPddQrzgx
	t7g0L10vOT93EyMkrL/sYFx8zOoQowAHoxIPr4RBaLAQa2JZcWXuIUYJDmYlEd4mzbBgId6U
	xMqq1KL8+KLSnNTiQ4xMHJxSDYzrjs58zxPaurfQ5MjGjv7Cc6GHZhzy+P2hSmmVlsmz661a
	Hj3zntc7RB6+PzP0la8i81GbA0s/e1wym1GavyM5s/TkZdVksf0la0L/mWzJELvJO7X63O9g
	4xfWaQevM2obMa+aJ+sksebUkuWZTtncTAI3J4c1ahzcL11295HRjqXzT6uVbLNTYinOSDTU
	Yi4qTgQAGpUpokkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-04-22 at 09:09 +0100, Lee Jones wrote:
> > > > +	unsigned long device_type;
> > > >  	int ret;
> > > >  
> > > >  	sec_pmic = devm_kzalloc(&i2c->dev, sizeof(struct sec_pmic_dev),
> > > > @@ -262,7 +263,7 @@ static int sec_pmic_probe(struct i2c_client *i2c,
> > > >  	sec_pmic->dev = &i2c->dev;
> > > >  	sec_pmic->i2c = i2c;
> > > >  	sec_pmic->irq = i2c->irq;
> > > > -	sec_pmic->type = sec_i2c_get_driver_data(i2c, id);
> > > > +	device_type = sec_i2c_get_driver_data(i2c, id);
> > > 
> > > Better to change the return type of 'sec_i2c_get_driver_data()' than
> > > to rely on a cast later on.
> > 
> > Hmmm... it was like that before Pankaj Dubey change (8f695de515b9).
> > Solving that issue (-Wpointer-to-int-cast) along with keeping 'int' as
> > return type of sec_i2c_get_driver_data would lead to one of:
> > 1. Using temporary variable in ec_i2c_get_driver_data just for cast.
> > 
> > static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
> > 						const struct i2c_device_id *id)
> > {
> > 	unsigned long type;
> > 
> > 	if (i2c->dev.of_node) {
> > 		const struct of_device_id *match;
> > 		match = of_match_node(sec_dt_match, i2c->dev.of_node);
> > 		type = (unsigned long)match->data;
> > 	}
> > 	type = id->driver_data;
> > 
> > 	return (int)type;
> > }
> > 
> > or
> > 2. Double cast: (int)(unsigned long)match->data;
> > 
> > For me both are kind a ugly... What do you think?
> 
> I'm saying, why don't you change everything; the return value of
> sec_i2c_get_driver_data(), pdata->device_type and device_type to long
> or unsigned long? Then the only cast you need to do is from void*.

Aaaa, I got it. I'll sent next version of patch.

Best regards,
Krzysztof


