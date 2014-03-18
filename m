Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaCRIIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:08:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9560 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaCRIIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:08:19 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-1f-5327fef04a86
Message-id: <1395130095.13308.0.camel@AMDC1943>
Subject: Re: [PATCH] iio: cm36651: Fix i2c client leak and possible NULL
 pointer dereference
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Beomho Seo <beomho.seo@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Date: Tue, 18 Mar 2014 09:08:15 +0100
In-reply-to: <53274BDA.9070804@kernel.org>
References: <1394098390-11213-1-git-send-email-k.kozlowski@samsung.com>
 <53247EC9.6090505@kernel.org> <1395043273.3950.3.camel@AMDC1943>
 <53274BDA.9070804@kernel.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xa7of/qkHG8xdK25x+tM2dosHTauY
	LJZMns9qMe/IOxaLy7vmsDmwemxa1cnmseTNIVaPvi2rGD0+b5ILYInisklJzcksSy3St0vg
	ypj0dTdTwQTxihcfbBoYHwp1MXJySAiYSHw9cIANwhaTuHBvPZDNxSEksJRR4uX7SSwQzmdG
	iWmXNjODVPEK6Et8P93IDmILC8RJrP9ymRHEZhMwlti8fAnYJBEBdYlpM64wgdjMAh2MEk2f
	WEFsFgFVidtnZwLN4eDgFNCS2HFcFmL+KkaJxlPboOrVJSbNW8QMcZGSxO72TnaIuLzE5jVv
	oW4QlPgx+R7LBEaBWUhaZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkDD+
	uoNx6TGrQ4wCHIxKPLwv2dSDhVgTy4orcw8xSnAwK4nwLp0MFOJNSaysSi3Kjy8qzUktPsTI
	xMEp1cCYI8vf+nDDrwMZ/m4bpzTIrlzGszD2wKZTkhm8pk+KDj2rOx/mNEX2jcInR7dbxac2
	PVle9kvcNqTj6gMZ3w1hzpIfpcU4O44955rZMG9fzKqla69Li+dVz2S0+WrMXb8lLNh8V6eL
	4SKWB7J3BXvX1K3RLp1mfKq6oG7Kk7PX9nu7B+4/H2ejxFKckWioxVxUnAgA+r0hwkECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 19:24 +0000, Jonathan Cameron wrote:
> On 17/03/14 08:01, Krzysztof Kozlowski wrote:
> > Hi,
> >
> > On Sat, 2014-03-15 at 16:24 +0000, Jonathan Cameron wrote:
> >> On 06/03/14 09:33, Krzysztof Kozlowski wrote:
> >>> During probe the driver allocates dummy I2C devices (i2c_new_dummy())
> >>> but they aren't unregistered during driver remove or probe failure.
> >>>
> >>> Additionally driver does not check the return value of i2c_new_dummy().
> >>> In case of error (i2c_new_device(): memory allocation failure or I2C
> >>> address cannot be used) this function returns NULL which is later
> >>> dereferenced by i2c_smbus_{read,write}_data() functions.
> >>>
> >>> Fix issues by properly checking for i2c_new_dummy() return value and
> >>> unregistering I2C devices on driver remove or probe failure.
> >>>
> >>> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> >> Good catch, but the error path needs more care.
> >>> ---
> >>>    drivers/iio/light/cm36651.c |   12 ++++++++++++
> >>>    1 file changed, 12 insertions(+)
> >>>
> >>> diff --git a/drivers/iio/light/cm36651.c b/drivers/iio/light/cm36651.c
> >>> index a45e07492db3..e7e9a597159f 100644
> >>> --- a/drivers/iio/light/cm36651.c
> >>> +++ b/drivers/iio/light/cm36651.c
> >>> @@ -653,6 +653,11 @@ static int cm36651_probe(struct i2c_client *client,
> >>>    	cm36651->ps_client = i2c_new_dummy(client->adapter,
> >>>    						     CM36651_I2C_ADDR_PS);
> >>>    	cm36651->ara_client = i2c_new_dummy(client->adapter, CM36651_ARA);
> >>> +	if (!cm36651->ps_client || !cm36651->ara_client) {
> >>> +		dev_err(&client->dev, "%s: new i2c device failed\n", __func__);
> >>> +		ret = -ENODEV;
> >>> +		goto error_i2c_unregister;
> >>> +	}
> >> The two failures need to be handled independently as we only want to unregister
> >> those that succeeded.  i2c_new_dummy will not return an error and leave a device
> >> registered.  This is particularly true given the first thing that i2c_unregister_device
> >> does is to derefence the client pointer.  That will cause a segfault if you do it
> >> for NULL as here.
> >>
> >
> > Where the segfault would occur? If i2c_new_dummy fails then
> > i2c_unregister_device() will be called only on NON-null values:
> > 	+error_i2c_unregister:
> > 	+	if (cm36651->ps_client)
> > 	+		i2c_unregister_device(cm36651->ps_client);
> > 	+	if (cm36651->ara_client)
> > 	+		i2c_unregister_device(cm36651->ara_client);
> >
> > If probe() succeeds (both i2c_new_dummy return proper pointer) then
> > remove() will unregister two i2c devices.
> >
> Oops, I missed that.  Still, the form of this is unusual so please
> change it to the more conventional option of a goto per error rather
> than grouping them.  That will also allow you to drop the null checks
> below leading to a more obviously correct error path.

Sure, I'll send a fixed version.

Best regards,
Krzysztof


