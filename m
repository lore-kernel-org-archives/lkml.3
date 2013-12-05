Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3LERuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:50:04 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:33067 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab3LERhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Dec 2013 18:43:38 +0100
From: Stefan Agner <stefan@agner.ch>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: thierry.reding@gmail.com, dev@lynxeye.de, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mfd: tps6586x: add version detection
In-Reply-To: <52A0B2AF.60803@wwwdotorg.org>
References: <cover.1386108712.git.stefan@agner.ch>
 <77384d24810d9a22fc04cad6f7468f54a9cbaafe.1386108712.git.stefan@agner.ch>
 <52A0B2AF.60803@wwwdotorg.org>
Message-ID: <b2a1db4167d319d355dd2a3a844553bc@agner.ch>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2013-12-05 18:06, schrieb Stephen Warren:
<snip>
>> @@ -493,13 +527,12 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
>>  		return -EIO;
>>  	}
>>
>> -	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
>> -
>>  	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
>> -	if (tps6586x == NULL) {
>> -		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
>> +	if (!tps6586x)
>>  		return -ENOMEM;
>> -	}
>> +
>> +	tps6586x->version = ret;
> 
> I have to say, I dislike this version of the patch. Separating the
> reading of the version register from the assignment to tps6586x->version
> doesn't make any sense, especially given that the version value is
> stored in a variable named "ret"; that name isn't remotely related to
> what's stored there. What if someone comes along later and adds more
> code that assigns to ret between where it's repurposed for the version
> value and where it's assigned to tps6586x->version? It'd be extremely
> difficult for a patch reviewer to spot that given the limited context in
> a diff, and quite non-obvious to the person changing the code too..

The value comes from the return value of i2c_smbus_read_byte_data. If
the value is below zero its an EIO error. 

I could add a variable "version", but for me it felt strange because we
check if version is below zero. This feels like its a wrong version
rather than a transmit error. So I would prefer ret over version. But I
agree, when one just reads the patch, its not obvious what exactly
happens.

In v2, I moved the i2c_smbus_read_byte_data function call after the
allocation, so it was more obvious for the reader. But then, as Thierry
Reding pointed out, not moving it is an optimization: In case reading
fails, we don't allocate memory first.
