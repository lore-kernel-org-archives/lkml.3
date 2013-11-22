Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab3KVOjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:39:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50510 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3KVOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:39:11 -0500
Message-ID: <528F6C10.5050704@ti.com>
Date: Fri, 22 Nov 2013 10:37:04 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>,
        <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 06/20] hwmon: lm75: expose to thermal fw via DT nodes
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-7-git-send-email-eduardo.valentin@ti.com> <20131115084354.656452b9@endymion.delvare> <528A23DD.2070406@ti.com> <20131119103948.0ec9daba@endymion.delvare>
In-Reply-To: <20131119103948.0ec9daba@endymion.delvare>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="BKovX2hTRIT86UF6l6o0gW8qaXc4HRdJe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BKovX2hTRIT86UF6l6o0gW8qaXc4HRdJe
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Jean,


On 19-11-2013 05:39, Jean Delvare wrote:
> Hi Eduardo,
>=20
> On Mon, 18 Nov 2013 10:27:41 -0400, Eduardo Valentin wrote:
>> The patch series have been looked and contributed by several people an=
d
>> a couple o maintainers now. Starts to be way better than the original
>> RFC. The core idea still holds though.
>=20
> I have no objection to the core idea, it's great :-)
>=20

This is good, thanks for the support.

>>>> (...)
>>>>  /*-----------------------------------------------------------------=
------*/
>>>> =20
>>>> +static inline long lm75_reg_to_mc(s16 temp, u8 resolution)
>>>> +{
>>>> +	return ((temp >> (16 - resolution)) * 1000) >> (resolution - 8);
>>>> +}
>>>> +
>>>>  /* sysfs attributes for hwmon */
>>>> =20
>>>> +static int lm75_read_temp(void *dev, long *temp)
>>>> +{
>>>> +	struct lm75_data *data =3D lm75_update_device(dev);
>>>> +
>>>> +	if (IS_ERR(data))
>>>> +		return PTR_ERR(data);
>>>> +
>>>> +	*temp =3D lm75_reg_to_mc(data->temp[0], data->resolution);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static ssize_t show_temp(struct device *dev, struct device_attribut=
e *da,
>>>>  			 char *buf)
>>>>  {
>>>>  	struct sensor_device_attribute *attr =3D to_sensor_dev_attr(da);
>>>>  	struct lm75_data *data =3D lm75_update_device(dev);
>>>> -	long temp;
>>>> =20
>>>>  	if (IS_ERR(data))
>>>>  		return PTR_ERR(data);
>>>> =20
>>>> -	temp =3D ((data->temp[attr->index] >> (16 - data->resolution)) * 1=
000)
>>>> -	       >> (data->resolution - 8);
>>>> -
>>>> -	return sprintf(buf, "%ld\n", temp);
>>>> +	return sprintf(buf, "%ld\n", lm75_reg_to_mc(data->temp[attr->index=
],
>>>> +						    data->resolution));
>>>>  }
>>>
>>> I am a bit worried by this. I did expect that you'd have to split a
>>> piece of show_temp() into one separate function, not two. Here you ha=
ve
>>> quite some redundancy between lm75_read_temp and show_temp. Sure thes=
e
>>> are small functions so the duplicate code is limited, but if you
>>> multiply by the number of hwmon drivers which are candidates for this=

>>> change, this all adds up.
>>
>> Can you please elaborate a bit more on which way you think the code
>> above shall be improved? Are you suggesting we should make show_temp
>> call lm75_read_temp?
>=20
> Yes, that's pretty much what I had in mind.
>=20

OK.

>> On this specific case, I believe the code
>> duplication is minor, although I haven't measured.
>=20
> I do agree the duplication in a single driver is minor. However I
> expect more hwmon drivers to be converted to cooperate with the thermal=

> subsystem in the future. Duplicated code adds up, in terms of build
> time, storage space and run-time memory consumption. Plus it hurts CPU
> caching even though I don't expect these code paths to be particularly
> hot.
>=20
> OTOH I suppose that the compiler will inline lm75_reg_to_mc() in this
> specific case, saving one function call. It wouldn't possibly inline
> lm75_read_temp() so it is quite possible that your implementation
> actually performs better than what I am suggesting.
>=20
> We're speaking of hardly measurable differences anyway. My other point
> below is probably more important...
>=20

Yeah, but I see your point. You probably want to have first code changes
done properly so that if we have code duplication, it does not spread
like a disease, like usually does. It is unavoidable to base new drivers
on existing ones. So better to get first converted drivers to be done
properly. I like this approach.

>>>> =20
>>>>  static ssize_t set_temp(struct device *dev, struct device_attribute=
 *da,
>>>> @@ -271,6 +288,13 @@ lm75_probe(struct i2c_client *client, const str=
uct i2c_device_id *id)
>>>>  		goto exit_remove;
>>>>  	}
>>>> =20
>>>> +	data->tz =3D thermal_zone_of_sensor_register(&client->dev,
>>>> +						   0,
>>>> +						   &client->dev,
>>>> +						   lm75_read_temp, NULL);
>>>
>>> I am also worried by this interface. Basically a separate callback
>>> function (here lm75_read_temp) is needed for every thermal input. Som=
e
>>> hwmon drivers have many of these! This will result in duplicate code
>>
>> The code registering a callback can actually have a private data, in
>> case you need to differentiate between inputs or in case you need to
>> derive specific data in order to access the correct input.
>=20
> Are you talking about void *dev? OK, you can virtually pass anything in=

> that pointer, but...

Yes.

>=20
>>> again. If you could just pass a sensor ID as an extra parameter to
>>> lm75_read_temp, you could use the same callback for all sensors. This=

>>
>> Wouldn't the private pointer be enough?
>=20
> I am worried that this won't be practical at all for the real world
> cases. I expect that most drivers will need to pass the device plus one=

> index-like value. Having a single void pointer for that is certainly
> flexible but it will also be inefficient, as every driver will have to
> define its own custom structure to embed the needed information. You

I see. Check patch 08/20 of this series. The driver had already
sensor/input id embedded in its own driver data. So, it was just a
matter of passing the complete driver data and then fetching id from the
passed driver data. Then again, that was only one case, if all other
potential API user drivers need to be modified to create their own
custom structure just for passing id, I definitely agree that it is
better to change the proposed API.

> _do_ pass a sensor_id to thermal_zone_of_sensor_register() so it
> shouldn't be hard to pass it to the callback function(s) as well
> (assuming the indexing in the device tree matches the one done by the
> driver - I certainly hope so.) I'd even suggest passing the device

Yes the ids from DT and driver layer must match.

> unconditionally too, as I just can't see how a driver could do without
> it. If you pass the right parameters then you may not even need a void
> pointer.

OK. So I assume you are proposing something like:
	.get_temp(struct device *dev, int id, long *temp);

right?




>=20
>> I think it is a matter of checking what is the best way for the
>> candidates of users of this new API.
>=20
> I agree. But two drivers are probably too few to make an educated
> decision, I suppose we'll need to convert some more to get a clearer

Yeah, I agree. The driver I chose were obviously based on the needs I
have to support the boards I have available/access.


> view. Note that most things can be changed later if needed, so my
> comments aren't meant to block the integration of your patches.=20

OK. I agree that this patch series maybe does not take into
consideration the complete driver population. However, I must agree that
driver migration can be done latter. Actually on both sides that is
required, from thermal and from hwmon.

I was already prompted about the strategy on this subject. My plan is
still to settle first the DT bindings, then the layers and APIs, then
add support on driver side. In order to show that the proposal works on
all fronts, I picked a sample of drivers to make things working on
existing boards, like DRA7-evm, panda 4430 and 4460, OMAP5432-uevm,
where we have both SoC sensors and board sensors.

DT bindings seams to be the most hard part, as there is no well
settle/defined standard to follow. The closest we can have is ACPI,
which is not applicable fully, otherwise we wouldn't be having this
discussion. However, I believe now the binding is more or less defined.
But I didn't get an official ack from DT folks though.

In the end of the day, the APIs and driver support will be really well
defined when we convert most of the drivers. But I would like to this in
a separated patch series.

What is your view? Are you OK if we integrate this series as a first
step of the complete process?

>=20
>> In theory it is enough to hold the
>> ID on the data structure you pass through the void * parameter. Howeve=
r,
>> that would cause less impact if you have the users of the API already
>> structured in that way. Let me know what is best for your case.
>=20
> We do not have that structure (struct device *, int index) ready yet,
> so we'd have to add it to every driver with more than one input. We
> could have a generic structure for that in some header file, to avoid
> the duplicated work, but if we need to do that, I'd say this is a good
> hint that we settled for the wrong API in the first place.

I see. I think we need to take into account the driver needs while
converting them. Assuming you are seeing a need to have these
parameters, I would guess it is a good advice, based on the fact that
you know better the existing hwmon drivers.

>=20
>>> (...)
>>> I also note the lack of support for limits. Thermal zones can have
>>> limits, and the various hwmon drivers do support that, yet your
>>> interface offers no possibility to expose them. Wouldn't that be usef=
ul?
>=20
> No comment on that? I'd expect the get_temp() callback to take an extra=

> parameter so that it can return the value of a specific subfeature, for=

> example INPUT, HOT, CRITICAL etc. Or leave get_temp() as is but add a
> get_trip_temp() callback to retrieve limit information (not sure if
> thermal zones can have more than one limit?)
>=20
> I think thermal zones support hysteresis as well, and so do many hwmon
> drivers. It seems unfortunate that your proposed "bridge" between the
> hwmon and thermal subsystems doesn't map all the features which are
> supported on both sides.

Yeah, it is back to the point that I am taking small steps here.

The hysteresis, and other properties, like update rate, or limits, in
fact need to be propagated down to driver layer. This way, hardware
features like interrupts and counters can be properly configured. So
far, the code now handles this in the DT glue layer, which means, the
thermal framework will be polling the hardware.

>=20
>>>> +	if (IS_ERR(data->tz))
>>>> +		data->tz =3D NULL;
>>>
>>> If you are doing that in all drivers, I would question the point of
>>> having thermal_zone_of_sensor_register() return a PTR_ERR in the firs=
t
>>> place.
>>
>> Yeah, maybe it should simply return NULL in the fail path and drivers
>> would not need to bother about it. What do you think?
>=20
> I think exactly what I wrote above, no more no less. I don't think I
> can add anything, and the decision is up to you.
>=20

OK.

Thanks for the good feedback.

--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--BKovX2hTRIT86UF6l6o0gW8qaXc4HRdJe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKPbBAACgkQCXcVR3XQvP1HeQD9FB493bRHn25A/77hJ2wdUqAe
dI77F5T8utFRy2bMq+sA/0um8YzGF2ZdfGqBX1pOgdNA9HmXtfVbuAqeTJWNvuL/
=u1jP
-----END PGP SIGNATURE-----

--BKovX2hTRIT86UF6l6o0gW8qaXc4HRdJe--
