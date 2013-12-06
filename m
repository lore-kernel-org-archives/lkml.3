Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3LFIpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:45:04 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50647 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab3LFIo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:44:59 -0500
Date: Fri, 6 Dec 2013 08:44:53 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        dev@lynxeye.de, lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mfd: tps6586x: add version detection
Message-ID: <20131206084453.GB13093@lee--X1>
References: <cover.1386108712.git.stefan@agner.ch>
 <77384d24810d9a22fc04cad6f7468f54a9cbaafe.1386108712.git.stefan@agner.ch>
 <52A0B2AF.60803@wwwdotorg.org>
 <b2a1db4167d319d355dd2a3a844553bc@agner.ch>
 <52A0BA85.4020201@wwwdotorg.org>
 <ac11b85d05765b3b68eff8c27041e965@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac11b85d05765b3b68eff8c27041e965@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> <snip>
> >>>> @@ -493,13 +527,12 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
> >>>>  		return -EIO;
> >>>>  	}
> >>>>
> >>>> -	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
> >>>> -
> >>>>  	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
> >>>> -	if (tps6586x == NULL) {
> >>>> -		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
> >>>> +	if (!tps6586x)
> >>>>  		return -ENOMEM;
> >>>> -	}
> >>>> +
> >>>> +	tps6586x->version = ret;
> >>>
> >>> I have to say, I dislike this version of the patch. Separating the
> >>> reading of the version register from the assignment to tps6586x->version
> >>> doesn't make any sense, especially given that the version value is
> >>> stored in a variable named "ret"; that name isn't remotely related to
> >>> what's stored there. What if someone comes along later and adds more
> >>> code that assigns to ret between where it's repurposed for the version
> >>> value and where it's assigned to tps6586x->version? It'd be extremely
> >>> difficult for a patch reviewer to spot that given the limited context in
> >>> a diff, and quite non-obvious to the person changing the code too..
> >>
> >> The value comes from the return value of i2c_smbus_read_byte_data. If
> >> the value is below zero its an EIO error.
> >>
> >> I could add a variable "version", but for me it felt strange because we
> >> check if version is below zero. This feels like its a wrong version
> >> rather than a transmit error. So I would prefer ret over version. But I
> >> agree, when one just reads the patch, its not obvious what exactly
> >> happens.
> > 
> > In my opinion, using a variable named "version" here would be
> > preferable. Testing that against <0 is just the way the I2C API works,
> > so the same argument could be applied to any I2C access.

So, FWIW I agree with Stephen and have done from the start. Please
see my original comment from the first submission:

> >       ret = i2c_smbus_read_byte_data(client, TPS6586X_VERSIONCRC);
>   If you're going to do this, please change 'ret' to 'version'.

> Hm, I try the empiric way:
> 
> $ grep -r -e i2c_smbus_read_byte_data | grep "ret =" | wc -l
> 139
> $ grep -r -e i2c_smbus_read_byte_data | grep "version =" | wc -l
> 3
> 
> Ok, thats not fair at all, version is usage specific whilst ret is not.
> 
> $ grep -r -e i2c_smbus_read_byte_data | grep " = " | wc -l
> 703

I not really that worried about what everyone else does. I'm more
concerned with doing what we deem to be the correct thing here.

> On the other hand is the additional variable. But I think the compiler
> will optimize that anyway, so this might not be an argument at all :-)
> 
> I see your point... Should I create another patch revision? Lee, is the
> patch already merged?

It isn't. Please submit another version as Stephen requests.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
