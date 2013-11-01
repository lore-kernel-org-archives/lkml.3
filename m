Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3KAClj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:41:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab3KAClh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:41:37 -0400
Date: Fri, 1 Nov 2013 13:41:20 +1100
From: NeilBrown <neilb@suse.de>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 2/2] LEDS: tca6502: add device-tree support for GPIO
 configuration.
Message-ID: <20131101134120.13a44225@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/uGx.DUPKp9iolnOvMxY21Jz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uGx.DUPKp9iolnOvMxY21Jz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


The 7 lines driven by the TCA6507 can either drive LEDs or act as output-on=
ly
GPIOs.

To make this distinction in devicetree we use the "compatible" property.

If the device attached to a line is "compatible" with "gpio", we treat it
like a GPIO.  If it is "compatible" with "led" (or if no "compatible" value
is set) we treat it like an LED.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documenta=
tion/devicetree/bindings/leds/tca6507.txt
index 80ff3dfb1f32..d7221b84987c 100644
--- a/Documentation/devicetree/bindings/leds/tca6507.txt
+++ b/Documentation/devicetree/bindings/leds/tca6507.txt
@@ -2,6 +2,13 @@ LEDs connected to tca6507
=20
 Required properties:
 - compatible : should be : "ti,tca6507".
+- #address-cells: must be 1
+- #size-cells: must be 0
+- reg: typically 0x45.
+
+Optional properties:
+- gpio-controller: allows lines to be used as output-only GPIOs.
+- #gpio-cells: if present, must be 0.
=20
 Each led is represented as a sub-node of the ti,tca6507 device.
=20
@@ -10,6 +17,7 @@ LED sub-node properties:
 - reg : number of LED line (could be from 0 to 6)
 - linux,default-trigger : (optional)
    see Documentation/devicetree/bindings/leds/common.txt
+- compatible: either "led" (the default) or "gpio".
=20
 Examples:
=20
@@ -19,6 +27,9 @@ tca6507@45 {
 	#size-cells =3D <0>;
 	reg =3D <0x45>;
=20
+	gpio-controller;
+	#gpio-cells =3D <2>;
+
 	led0: red-aux@0 {
 		label =3D "red:aux";
 		reg =3D <0x0>;
@@ -29,5 +40,10 @@ tca6507@45 {
 		reg =3D <0x5>;
 		linux,default-trigger =3D "default-on";
 	};
+
+	wifi-reset@6 {
+		reg =3D <0x6>;
+		compatible =3D "gpio";
+	};
 };
=20
diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index f5063f447463..93a2b1759054 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -638,6 +638,9 @@ static int tca6507_probe_gpios(struct i2c_client *clien=
t,
 	tca->gpio.direction_output =3D tca6507_gpio_direction_output;
 	tca->gpio.set =3D tca6507_gpio_set_value;
 	tca->gpio.dev =3D &client->dev;
+#ifdef CONFIG_OF_GPIO
+	tca->gpio.of_node =3D of_node_get(client->dev.of_node);
+#endif
 	err =3D gpiochip_add(&tca->gpio);
 	if (err) {
 		tca->gpio.ngpio =3D 0;
@@ -696,6 +699,8 @@ tca6507_led_dt_init(struct i2c_client *client)
 		led.default_trigger =3D
 			of_get_property(child, "linux,default-trigger", NULL);
 		led.flags =3D 0;
+		if (of_property_match_string(child, "compatible", "gpio") >=3D 0)
+			led.flags |=3D TCA6507_MAKE_GPIO;
 		ret =3D of_property_read_u32(child, "reg", &reg);
 		if (ret !=3D 0 || reg < 0 || reg >=3D NUM_LEDS)
 			continue;
@@ -709,6 +714,7 @@ tca6507_led_dt_init(struct i2c_client *client)
=20
 	pdata->leds.leds =3D tca_leds;
 	pdata->leds.num_leds =3D NUM_LEDS;
+	pdata->gpio_base =3D -1;
=20
 	return pdata;
 }

--Sig_/uGx.DUPKp9iolnOvMxY21Jz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnMU0Tnsnt1WYoG5AQLRbBAAnHQSSOQNdhdCMgyYRvXPes9Na28V1zQY
qal2QDXr+kx2Y51IDm/ji1GRTecfLenK3fZEUNYdkJjYAg3QxwB5rkj7wucZ1E3Z
bSUuB3J+W8ycuKk8i4f0mDstnSjjEgvGw1GQRgFrEgdB/3DWxsPa3COdNN8XIOf8
mJcKG5EnKukW5wPsMcKHeNq3uQ0LoSfZpgOyoJfhzKDAMzfF+0mDfjxzqDe90d8X
etCLyiVMX96ElndE/N2ApVYLQWdBYYHc2t9hh43PAOJbzaD2APMbeioiueZl9Slj
h7TpsJmkSTOun20vs7Fj+gRLngvOJqWZhoBINtLNUhn0N62d4fbK9gFSbzhuju+r
ymmte0l+9+EeE/fiJnotcoTX+bKdDY1wVVuBVMmw1iDoJnMhwdABOIpVQ5OdqC5b
wfe8txqBxKWiBMUAQ0LYfSjegvonIT6ZoxpUEXuSDGKp3fWQ7p4DSE4p+D5wz418
XYSsghsBoYwnnoEjrLg1oOttqeLJYKsY0hThxDW/13PpL9ruHtQ7wB/OSNR7nKJX
70+fw5bM5JeUkgRQbGSHLmqR7rDXPiu6SEEhRqavOzM2Ow4TPt3T6sT6vlrdkd3z
iQTMSJ2U6naBaSAjkqBVHLqRYce4IzfqGMROjgKn821+2Yy3ACHb/N1qy0f8KTCY
bI9IizLHr+4=
=Hlpj
-----END PGP SIGNATURE-----

--Sig_/uGx.DUPKp9iolnOvMxY21Jz--
