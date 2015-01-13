Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbbAMRpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:45:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48326 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbbAMRpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:45:13 -0500
Message-ID: <54B55993.4020806@pengutronix.de>
Date: Tue, 13 Jan 2015 18:44:51 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, wg@grandegger.com,
        michal.simek@xilinx.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v5] can: Convert to runtime_pm
References: <baf987c11c0242c2bf87b81f9396b09d@BN1BFFO11FD018.protection.gbl> <3a3437c5c8ff48d9a45fee7e81fa8dca@BY2FFO11FD058.protection.gbl> <54B4FCB5.6040904@pengutronix.de> <6ea3c0ea0f5c4deb9a6e4738a8d94a36@BN1AFFO11FD047.protection.gbl> <54B55326.1060606@pengutronix.de> <1ef3e0f060f54c888061514bd2926762@BY2FFO11FD033.protection.gbl>
In-Reply-To: <1ef3e0f060f54c888061514bd2926762@BY2FFO11FD033.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="us25MiQkMcVQnudKqAhiaCbUgJr8xqOwT"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--us25MiQkMcVQnudKqAhiaCbUgJr8xqOwT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/13/2015 06:24 PM, S=C3=B6ren Brinkmann wrote:
> On Tue, 2015-01-13 at 06:17PM +0100, Marc Kleine-Budde wrote:
>> On 01/13/2015 06:08 PM, S=C3=B6ren Brinkmann wrote:
>>> On Tue, 2015-01-13 at 12:08PM +0100, Marc Kleine-Budde wrote:
>>>> On 01/12/2015 07:45 PM, S=C3=B6ren Brinkmann wrote:
>>>>> On Mon, 2015-01-12 at 08:34PM +0530, Kedareswara rao Appana wrote:
>>>>>> Instead of enabling/disabling clocks at several locations in the d=
river,
>>>>>> Use the runtime_pm framework. This consolidates the actions for ru=
ntime PM
>>>>>> In the appropriate callbacks and makes the driver more readable an=
d mantainable.
>>>>>>
>>>>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>>>>> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
>>>>>> ---
>>>>>> Changes for v5:
>>>>>>  - Updated with the review comments.
>>>>>>    Updated the remove fuction to use runtime_pm.
>>>>>> Chnages for v4:
>>>>>>  - Updated with the review comments.
>>>>>> Changes for v3:
>>>>>>   - Converted the driver to use runtime_pm.
>>>>>> Changes for v2:
>>>>>>   - Removed the struct platform_device* from suspend/resume
>>>>>>     as suggest by Lothar.
>>>>>>
>>>>>>  drivers/net/can/xilinx_can.c |  157 ++++++++++++++++++++++++++++-=
------------
>>>>>>  1 files changed, 107 insertions(+), 50 deletions(-)
>>>>> [..]
>>>>>> +static int __maybe_unused xcan_runtime_resume(struct device *dev)=

>>>>>>  {
>>>>>> -	struct platform_device *pdev =3D dev_get_drvdata(dev);
>>>>>> -	struct net_device *ndev =3D platform_get_drvdata(pdev);
>>>>>> +	struct net_device *ndev =3D dev_get_drvdata(dev);
>>>>>>  	struct xcan_priv *priv =3D netdev_priv(ndev);
>>>>>>  	int ret;
>>>>>> +	u32 isr, status;
>>>>>> =20
>>>>>>  	ret =3D clk_enable(priv->bus_clk);
>>>>>>  	if (ret) {
>>>>>> @@ -1014,15 +1030,28 @@ static int __maybe_unused xcan_resume(stru=
ct device *dev)
>>>>>>  	ret =3D clk_enable(priv->can_clk);
>>>>>>  	if (ret) {
>>>>>>  		dev_err(dev, "Cannot enable clock.\n");
>>>>>> -		clk_disable_unprepare(priv->bus_clk);
>>>>>> +		clk_disable(priv->bus_clk);
>>>>> [...]
>>>>>> @@ -1173,12 +1219,23 @@ static int xcan_remove(struct platform_dev=
ice *pdev)
>>>>>>  {
>>>>>>  	struct net_device *ndev =3D platform_get_drvdata(pdev);
>>>>>>  	struct xcan_priv *priv =3D netdev_priv(ndev);
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	ret =3D pm_runtime_get_sync(&pdev->dev);
>>>>>> +	if (ret < 0) {
>>>>>> +		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
>>>>>> +				__func__, ret);
>>>>>> +		return ret;
>>>>>> +	}
>>>>>> =20
>>>>>>  	if (set_reset_mode(ndev) < 0)
>>>>>>  		netdev_err(ndev, "mode resetting failed!\n");
>>>>>> =20
>>>>>>  	unregister_candev(ndev);
>>>>>> +	pm_runtime_disable(&pdev->dev);
>>>>>>  	netif_napi_del(&priv->napi);
>>>>>> +	clk_disable_unprepare(priv->bus_clk);
>>>>>> +	clk_disable_unprepare(priv->can_clk);
>>>>>
>>>>> Shouldn't pretty much all these occurrences of clk_disable/enable
>>>>> disappear? This should all be handled by the runtime_pm framework n=
ow.
>>>>
>>>> We have:
>>>> - clk_prepare_enable() in probe
>>>
>>> This should become something like pm_runtime_get_sync(), shouldn't it=
?
>>>
>>>> - clk_disable_unprepare() in remove
>>>
>>> pm_runtime_put()
>>>
>>>> - clk_enable() in runtime_resume
>>>> - clk_disable() in runtime_suspend
>>>
>>> These are the ones needed.
>>>
>>> The above makes me suspect that the clocks are always on, regardless =
of
>>
>> Define "on" :)
>> The clocks are prepared after probe() exists, but not enabled. The fir=
st
>> pm_runtime_get_sync() will enable the clocks.
>>
>>> the runtime suspend state since they are enabled in probe and disable=
d
>>> in remove, is that right? Ideally, the usage in probe and remove shou=
ld
>>> be migrated to runtime_pm and clocks should really only be running wh=
en
>>> needed and not throughout the whole lifetime of the driver.
>>
>> The clocks are not en/disabled via pm_runtime, because
>> pm_runtime_get_sync() is called from atomic contect. We can have anoth=
er
>> look into the driver and try to change this.

> Wasn't that why the call to pm_runtime_irq_safe() was added?

Good question. That should be investigated.

> Also, clk_enable/disable should be okay to be run from atomic context.
> And if the clock are already prepared after the exit of probe that
> should be enough. Then remove() should just have to do the unprepare.
> But I don't see why runtime_pm shouldn't be able to do the
> enable/disable.

runtime_pm does call the clk_{enable,disable} function. But you mean
clk_prepare() + pm_runtime_get_sync() should be used in probe() instead
of calling clk_prepare_enable(). Good idea! I think the
"pm_runtime_set_active(&pdev->dev);" has to be removed from the patch.

Coming back whether blocking calls are allowed or not.
If you make a call to pm_runtime_irq_safe(), you state that it's okay to
call pm_runtime_get_sync() from atomic context. But it's only called in
open, probe, remove and in xcan_get_berr_counter, which is not called
from atomic either. So let's try to remove the pm_runtime_irq_safe() and
use clk_prepare_enable() clk_disable_unprepare() in the runtime_resume()
runtime_suspend() functions.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--us25MiQkMcVQnudKqAhiaCbUgJr8xqOwT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtVmTAAoJECte4hHFiupU1FUQAIdZNssAS+zUZi+n5TEf/nNF
PJr4T2/pDK5wmtY94YcJJInj2QafyIflwD62iV3a1OyB4bog9oYM1ykV7l30v/it
DUcERzWgBjdAI1xbJ9ZsTjpd0pIZIlPxgZbFBEKjWwKSg0gO3Rz4tnOxYI4+6fzV
UDfEjK8kTLdS1y1MoUyFM/9HRxA+XCH6upuVZAf6wTw46747PFXj5qkGoOhhfkUl
mrn2fgB+fT4QkAEXNRtceLLG40u2OT/t/KkwggKjOQfI+x3fXdenCtEA1nXAWPBr
j3EjKnZGbTrUQ353PLmufXrPNu3fH8DYP4UIr4UC4THkWXoCQ1+HiiN6KK7gRoeq
ATsisaKYVI+Gq1feqS+AaHja1sY4EZ9zsHqvy96mBxxPe4+IE+AuVnveeQPeXtku
2aLUQq/0MAqufN9xcLH8aGb1s5tZp+JTrJMnB1Q3NRLAP/rPhORhBexpLf97REKE
Aih7t9iIxaneXSYR3YwL5TvwIjAlGzRN/4UANZuL7qqHnUwiIucGryMqT4N2a22y
BhQkHHNEgv3ZzZ27/QtgEo7rzVrTiYncCA9e3CZY/cv5/6hFtqnIEnBMQuD6W0zR
xaQ/aA+GP/FkVn39vVpIF/Siu8dMZGf+g2fJqjBeD54karBEMGKhifHoLpEPyb3z
79+N+06qEEy8teM+YLe4
=bdOt
-----END PGP SIGNATURE-----

--us25MiQkMcVQnudKqAhiaCbUgJr8xqOwT--
