Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaJPO4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:56:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:52558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaJPO4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:56:02 -0400
Message-ID: <1413471356.2762.81.camel@infradead.org>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties
 support
From: David Woodhouse <dwmw2@infradead.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "dvhart@infradead.org" <dvhart@infradead.org>
Date: Thu, 16 Oct 2014 16:55:56 +0200
In-Reply-To: <543E9605.6020502@linux.intel.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
	 <1413378271.2762.77.camel@infradead.org>
	 <20141015131551.GC20034@leverpostej>
	 <1413379736.2762.79.camel@infradead.org>
	 <20141015134209.GD20034@leverpostej>
	 <db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
	 <543E88CF.5060504@linux.intel.com> <20141015151702.GG20034@leverpostej>
	 <543E9605.6020502@linux.intel.com>
Content-Type: multipart/signed; micalg="sha-1"; protocol="application/x-pkcs7-signature";
	boundary="=-rMsDKpiGyfKabkwiRXEy"
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20) 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rMsDKpiGyfKabkwiRXEy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-10-15 at 17:43 +0200, Darren Hart wrote:
>=20
> So my objection here is that by keeping the of_* terms in the driver we
> are required to include of, although it does safely convert to returning
> NULL if !CONFIG_OF I suppose.

New version removes everything but the of_match_id bits which we need to
match ACPI devices too. Perhaps they ought to be renamed, but I'm not
sure it's worth it.

This also removes the call to platform_get_resource(IORESOURCE_MEM) and
fall back to platform_get_resource(IORESOURCE_IO) as discussed IRL with
Rafael. I'm not sure it's much of an improvement, mind you :)

Still untested. I think it's OK to switch to platform_get_irq() and then
drop the irq_dispose_mapping() call, right? The platform_device takes
care of all of that for us?

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 26cec64..be95a4c 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1094,14 +1094,14 @@ config SERIAL_NETX_CONSOLE
 	  you can make it the console by answering Y to this option.
=20
 config SERIAL_OF_PLATFORM
-	tristate "Serial port on Open Firmware platform bus"
-	depends on OF
+	tristate "Serial port on firmware platform bus"
+	depends on OF || ACPI
 	depends on SERIAL_8250 || SERIAL_OF_PLATFORM_NWPSERIAL
 	help
-	  If you have a PowerPC based system that has serial ports
-	  on a platform specific bus, you should enable this option.
-	  Currently, only 8250 compatible ports are supported, but
-	  others can easily be added.
+	  If you have a system which advertises its serial ports through
+	  devicetree or ACPI, you should enable this option. Currently
+	  only 8250 compatible and NWP ports and are supported, but others
+	  can easily be added.
=20
 config SERIAL_OMAP
 	tristate "OMAP serial port support"
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.=
c
index 68d4455..cc6c99b 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -14,8 +14,7 @@
 #include <linux/delay.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
+#include <linux/property.h>
 #include <linux/of_platform.h>
 #include <linux/nwpserial.h>
 #include <linux/clk.h>
@@ -53,22 +52,22 @@ static inline void tegra_serial_handle_break(struct uar=
t_port *port)
 /*
  * Fill a struct uart_port for a given device node
  */
-static int of_platform_serial_setup(struct platform_device *ofdev,
+static int of_platform_serial_setup(struct platform_device *pdev,
 			int type, struct uart_port *port,
 			struct of_serial_info *info)
 {
-	struct resource resource;
-	struct device_node *np =3D ofdev->dev.of_node;
 	u32 clk, spd, prop;
-	int ret;
+	int iotype =3D -1;
+	u32 res_start;
+	int ret, i;
=20
 	memset(port, 0, sizeof *port);
-	if (of_property_read_u32(np, "clock-frequency", &clk)) {
+	if (device_property_read_u32(&pdev->dev, "clock-frequency", &clk)) {
=20
 		/* Get clk rate through clk driver if present */
-		info->clk =3D clk_get(&ofdev->dev, NULL);
+		info->clk =3D clk_get(&pdev->dev, NULL);
 		if (IS_ERR(info->clk)) {
-			dev_warn(&ofdev->dev,
+			dev_warn(&pdev->dev,
 				"clk or clock-frequency not defined\n");
 			return PTR_ERR(info->clk);
 		}
@@ -77,57 +76,63 @@ static int of_platform_serial_setup(struct platform_dev=
ice *ofdev,
 		clk =3D clk_get_rate(info->clk);
 	}
 	/* If current-speed was set, then try not to change it. */
-	if (of_property_read_u32(np, "current-speed", &spd) =3D=3D 0)
+	if (device_property_read_u32(&pdev->dev, "current-speed", &spd) =3D=3D 0)
 		port->custom_divisor =3D clk / (16 * spd);
=20
-	ret =3D of_address_to_resource(np, 0, &resource);
-	if (ret) {
-		dev_warn(&ofdev->dev, "invalid address\n");
+	/* Check for shifted address mapping */
+	if (device_property_read_u32(&pdev->dev, "reg-offset", &prop) !=3D 0)
+		prop =3D 0;
+
+	for (i =3D 0; iotype =3D=3D -1 && i < pdev->num_resources; i++) {
+		struct resource *resource =3D &pdev->resource[i];
+		if (resource_type(resource) =3D=3D IORESOURCE_MEM) {
+			iotype =3D UPIO_MEM;
+			port->mapbase =3D res_start + prop;
+		} else if (resource_type(resource) =3D=3D IORESOURCE_IO) {
+			iotype =3D UPIO_PORT;
+			port->iobase =3D res_start + prop;
+		}
+
+		res_start =3D resource->start;
+	}
+	if (iotype =3D=3D -1) {
+		dev_warn(&pdev->dev, "invalid address\n");
 		goto out;
 	}
=20
 	spin_lock_init(&port->lock);
-	port->mapbase =3D resource.start;
-
-	/* Check for shifted address mapping */
-	if (of_property_read_u32(np, "reg-offset", &prop) =3D=3D 0)
-		port->mapbase +=3D prop;
=20
 	/* Check for registers offset within the devices address range */
-	if (of_property_read_u32(np, "reg-shift", &prop) =3D=3D 0)
+	if (device_property_read_u32(&pdev->dev, "reg-shift", &prop) =3D=3D 0)
 		port->regshift =3D prop;
=20
 	/* Check for fifo size */
-	if (of_property_read_u32(np, "fifo-size", &prop) =3D=3D 0)
+	if (device_property_read_u32(&pdev->dev, "fifo-size", &prop) =3D=3D 0)
 		port->fifosize =3D prop;
=20
-	port->irq =3D irq_of_parse_and_map(np, 0);
-	port->iotype =3D UPIO_MEM;
-	if (of_property_read_u32(np, "reg-io-width", &prop) =3D=3D 0) {
-		switch (prop) {
-		case 1:
-			port->iotype =3D UPIO_MEM;
-			break;
-		case 4:
-			port->iotype =3D UPIO_MEM32;
-			break;
-		default:
-			dev_warn(&ofdev->dev, "unsupported reg-io-width (%d)\n",
+	port->irq =3D platform_get_irq(pdev, 0);
+
+	if (device_property_read_u32(&pdev->dev, "reg-io-width", &prop) =3D=3D 0)=
 {
+		if (prop =3D=3D 4 && iotype =3D=3D UPIO_MEM) {
+			iotype =3D UPIO_MEM32;
+		} else {
+			dev_warn(&pdev->dev, "unsupported reg-io-width (%d)\n",
 				 prop);
 			ret =3D -EINVAL;
 			goto out;
 		}
 	}
=20
+	port->iotype =3D iotype;
 	port->type =3D type;
 	port->uartclk =3D clk;
 	port->flags =3D UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
 		| UPF_FIXED_PORT | UPF_FIXED_TYPE;
=20
-	if (of_find_property(np, "no-loopback-test", NULL))
+	if (!device_get_property(&pdev->dev, "no-loopback-test", NULL))
 		port->flags |=3D UPF_SKIP_TEST;
=20
-	port->dev =3D &ofdev->dev;
+	port->dev =3D &pdev->dev;
=20
 	if (type =3D=3D PORT_TEGRA)
 		port->handle_break =3D tegra_serial_handle_break;
@@ -143,7 +148,7 @@ out:
  * Try to register a serial port
  */
 static struct of_device_id of_platform_serial_table[];
-static int of_platform_serial_probe(struct platform_device *ofdev)
+static int of_platform_serial_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 	struct of_serial_info *info;
@@ -151,11 +156,11 @@ static int of_platform_serial_probe(struct platform_d=
evice *ofdev)
 	int port_type;
 	int ret;
=20
-	match =3D of_match_device(of_platform_serial_table, &ofdev->dev);
+	match =3D of_match_device(of_platform_serial_table, &pdev->dev);
 	if (!match)
 		return -EINVAL;
=20
-	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
+	if (!device_get_property(&pdev->dev, "used-by-rtas", NULL))
 		return -EBUSY;
=20
 	info =3D kmalloc(sizeof(*info), GFP_KERNEL);
@@ -163,7 +168,7 @@ static int of_platform_serial_probe(struct platform_dev=
ice *ofdev)
 		return -ENOMEM;
=20
 	port_type =3D (unsigned long)match->data;
-	ret =3D of_platform_serial_setup(ofdev, port_type, &port, info);
+	ret =3D of_platform_serial_setup(pdev, port_type, &port, info);
 	if (ret)
 		goto out;
=20
@@ -179,12 +184,10 @@ static int of_platform_serial_probe(struct platform_d=
evice *ofdev)
 		if (port.fifosize)
 			port8250.capabilities =3D UART_CAP_FIFO;
=20
-		if (of_property_read_bool(ofdev->dev.of_node,
-					  "auto-flow-control"))
+		if (!device_get_property(&pdev->dev, "auto-flow-control", NULL))
 			port8250.capabilities |=3D UART_CAP_AFE;
=20
-		if (of_property_read_bool(ofdev->dev.of_node,
-					  "has-hw-flow-control"))
+		if (!device_get_property(&pdev->dev, "has-hw-flow-control", NULL))
 			port8250.port.flags |=3D UPF_HARD_FLOW;
=20
 		ret =3D serial8250_register_8250_port(&port8250);
@@ -199,7 +202,7 @@ static int of_platform_serial_probe(struct platform_dev=
ice *ofdev)
 	default:
 		/* need to add code for these */
 	case PORT_UNKNOWN:
-		dev_info(&ofdev->dev, "Unknown serial port found, ignored\n");
+		dev_info(&pdev->dev, "Unknown serial port found, ignored\n");
 		ret =3D -ENODEV;
 		break;
 	}
@@ -208,20 +211,19 @@ static int of_platform_serial_probe(struct platform_d=
evice *ofdev)
=20
 	info->type =3D port_type;
 	info->line =3D ret;
-	platform_set_drvdata(ofdev, info);
+	platform_set_drvdata(pdev, info);
 	return 0;
 out:
 	kfree(info);
-	irq_dispose_mapping(port.irq);
 	return ret;
 }
=20
 /*
  * Release a line
  */
-static int of_platform_serial_remove(struct platform_device *ofdev)
+static int of_platform_serial_remove(struct platform_device *pdev)
 {
-	struct of_serial_info *info =3D platform_get_drvdata(ofdev);
+	struct of_serial_info *info =3D platform_get_drvdata(pdev);
 	switch (info->type) {
 #ifdef CONFIG_SERIAL_8250
 	case PORT_8250 ... PORT_MAX_8250:


--=20
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

--=-rMsDKpiGyfKabkwiRXEy
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIISxDCCBjQw
ggQcoAMCAQICAR4wDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxKTAn
BgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3MTAyNDIxMDE1NVoX
DTE3MTAyNDIxMDE1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSsw
KQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFy
dENvbSBDbGFzcyAxIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMcJg8zOLdgasSmkLhOrlr6KMoOMpohBllVHrdRvEg/q6r8jR+EK
75xCGhR8ToREoqe7zM9/UnC6TS2y9UKTpT1v7RSMzR0t6ndl0TWBuUr/UXBhPk+Kmy7bI4yW4urC
+y7P3/1/X7U8ocb8VpH/Clt+4iq7nirMcNh6qJR+xjOhV+VHzQMALuGYn5KZmc1NbJQYclsGkDxD
z2UbFqE2+6vIZoL+jb9x4Pa5gNf1TwSDkOkikZB1xtB4ZqtXThaABSONdfmv/Z1pua3FYxnCFmdr
/+N2JLKutIxMYqQOJebr/f/h5t95m4JgrM3Y/w7YX9d7YAL9jvN4SydHsU6n65cCAwEAAaOCAa0w
ggGpMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBRTcu2SnODaywFc
fH6WNU7y1LhRgjAfBgNVHSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRa
MFgwJwYIKwYBBQUHMAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYh
aHR0cDovL3d3dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5j
b20vc2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBAAqDCH14qywG
XLhjjF6uHLkjd02hcdh9hrw+VUsv+q1eeQWB21jWj3kJ96AUlPCoEGZ/ynJNScWy6QMVQjbbMXlt
UfO4n4bGGdKo3awPWp61tjAFgraLJgDk+DsSvUD6EowjMTNx25GQgyYJ5RPIzKKR9tQW8gGK+2+R
HxkUCTbYFnL6kl8Ch507rUdPPipJ9CgJFws3kDS3gOS5WFMxcjO5DwKfKSETEPrHh7p5shuuNktv
sv6hxHTLhiMKX893gxdT3XLS9OKmCv87vkINQcNEcIIoFWbP9HORz9v3vQwR4e3ksLc2JZOAFK+s
sS5XMEoznzpihEP0PLc4dCBYjbvSD7kxgDwZ+Aj8Q9PkbvE9sIPP7ON0fz095HdThKjiVJe6vofq
+n6b1NBc8XdrQvBmunwxD5nvtTW4vtN6VY7mUCmxsCieuoBJ9OlqmsVWQvifIYf40dJPZkk9YgGT
zWLpXDSfLSplbY2LL9C9U0ptvjcDjefLTvqSFc7tw1sEhF0n/qpA2r0GpvkLRDmcSwVyPvmjFBGq
Up/pNy8ZuPGQmHwFi2/14+xeSUDG2bwnsYJQG2EdJCB6luQ57GEnTA/yKZSTKI8dDQa8Sd3zfXb1
9mOgSF0bBdXbuKhEpuP9wirslFe6fQ1t5j5R0xi72MZ8ikMu1RQZKCyDbMwazlHiMIIGQjCCBSqg
AwIBAgIDCdkyMA0GCSqGSIb3DQEBBQUAMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYG
A1UEAxMvU3RhcnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcN
MTQwNTA0MTczMDIyWhcNMTUwNTA0MjM0MTAxWjBdMRkwFwYDVQQNExAzODNCMTVkSHFQSUR0cDZO
MRwwGgYDVQQDDBNkd213MkBpbmZyYWRlYWQub3JnMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZy
YWRlYWQub3JnMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy7K+t+REIdZGFUfgR8Io
QrJ/VLZil9I00JcwqTo8BiGy1dqSIB2y923siya5SDKMh1YurtCPsX96cNzwPmmN2cs0MKeVPQWz
iQhHk3uKcB6LvvS7pzTahRWMRmTyW3CH+RphRM9plvyClY23GEeEnpBnGz4GaJJiPcJjGgzyZ/tI
q473pOlSrDPZnZk43vt/5CJN46nIZOZ2I+PzlgINI+EbiwsXVn3VohHB7nVTwGaRLk5oywGt8ZT7
tDdxn3BQ3inO1sr5MtkV1o2cHlenIC8mlU8nL/mrqqVve7Vib1YQUycW+Pj4CBYm4FTeuctAvNzK
U/daeBclOZ8ofgQe2wIDAQABo4IC2TCCAtUwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBRAjCSCV70BpLBeXge5DXi+mPhHTTAf
BgNVHSMEGDAWgBRTcu2SnODaywFcfH6WNU7y1LhRgjAeBgNVHREEFzAVgRNkd213MkBpbmZyYWRl
YWQub3JnMIIBTAYDVR0gBIIBQzCCAT8wggE7BgsrBgEEAYG1NwECAzCCASowLgYIKwYBBQUHAgEW
Imh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0
YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdh
cyBpc3N1ZWQgYWNjb3JkaW5nIHRvIHRoZSBDbGFzcyAxIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRz
IG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRl
ZCBwdXJwb3NlIGluIGNvbXBsaWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMu
MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL2NydHUxLWNybC5jcmww
gY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYBBQUHMAGGLWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9z
dWIvY2xhc3MxL2NsaWVudC9jYTBCBggrBgEFBQcwAoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20v
Y2VydHMvc3ViLmNsYXNzMS5jbGllbnQuY2EuY3J0MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3Rh
cnRzc2wuY29tLzANBgkqhkiG9w0BAQUFAAOCAQEAWS2KNN7O3vZVtNHXVqgbmijeptKwt+8b6yiF
wT3kJoywInPl5U+OeKRZfQKTHghM4Ohof6lF244ZMxhir/xp7l/zkZ/BUbxLwp6kIL27Gi5pgP4D
KLnTZheQL9N5Yi/vMONxMWcpcW+ZNv5hnDCfEsfVcLXC8sNLPjx2ezfMIhSSPwBuJpmOun70te4E
P0YBqjSalPfvc5fC5KgaYtqTDFwo9Mw25X5HHDC0r6BK5aNrF1nD/xYTX7cdvZZWl7cUApr4PCrn
uI2DEn7OWQ/rY407ytV1c5pjvmuv/IT/ZUb/kXV6Q47UvrJp2Ifi2VhsBcnHHasKavjtRCmpDsGM
rTCCBkIwggUqoAMCAQICAwnZMjANBgkqhkiG9w0BAQUFADCBjDELMAkGA1UEBhMCSUwxFjAUBgNV
BAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xp
ZW50IENBMB4XDTE0MDUwNDE3MzAyMloXDTE1MDUwNDIzNDEwMVowXTEZMBcGA1UEDRMQMzgzQjE1
ZEhxUElEdHA2TjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzEiMCAGCSqGSIb3DQEJARYT
ZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMuyvrfk
RCHWRhVH4EfCKEKyf1S2YpfSNNCXMKk6PAYhstXakiAdsvdt7IsmuUgyjIdWLq7Qj7F/enDc8D5p
jdnLNDCnlT0Fs4kIR5N7inAei770u6c02oUVjEZk8ltwh/kaYUTPaZb8gpWNtxhHhJ6QZxs+BmiS
Yj3CYxoM8mf7SKuO96TpUqwz2Z2ZON77f+QiTeOpyGTmdiPj85YCDSPhG4sLF1Z91aIRwe51U8Bm
kS5OaMsBrfGU+7Q3cZ9wUN4pztbK+TLZFdaNnB5XpyAvJpVPJy/5q6qlb3u1Ym9WEFMnFvj4+AgW
JuBU3rnLQLzcylP3WngXJTmfKH4EHtsCAwEAAaOCAtkwggLVMAkGA1UdEwQCMAAwCwYDVR0PBAQD
AgSwMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUQIwkgle9AaSwXl4H
uQ14vpj4R00wHwYDVR0jBBgwFoAUU3Ltkpzg2ssBXHx+ljVO8tS4UYIwHgYDVR0RBBcwFYETZHdt
dzJAaW5mcmFkZWFkLm9yZzCCAUwGA1UdIASCAUMwggE/MIIBOwYLKwYBBAGBtTcBAgMwggEqMC4G
CCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMIH3BggrBgEFBQcC
AjCB6jAnFiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgEBGoG+VGhpcyBjZXJ0
aWZpY2F0ZSB3YXMgaXNzdWVkIGFjY29yZGluZyB0byB0aGUgQ2xhc3MgMSBWYWxpZGF0aW9uIHJl
cXVpcmVtZW50cyBvZiB0aGUgU3RhcnRDb20gQ0EgcG9saWN5LCByZWxpYW5jZSBvbmx5IGZvciB0
aGUgaW50ZW5kZWQgcHVycG9zZSBpbiBjb21wbGlhbmNlIG9mIHRoZSByZWx5aW5nIHBhcnR5IG9i
bGlnYXRpb25zLjA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9jcnR1
MS1jcmwuY3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzABhi1odHRwOi8vb2NzcC5zdGFy
dHNzbC5jb20vc3ViL2NsYXNzMS9jbGllbnQvY2EwQgYIKwYBBQUHMAKGNmh0dHA6Ly9haWEuc3Rh
cnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczEuY2xpZW50LmNhLmNydDAjBgNVHRIEHDAahhhodHRw
Oi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQEFBQADggEBAFktijTezt72VbTR11aoG5oo
3qbSsLfvG+sohcE95CaMsCJz5eVPjnikWX0Ckx4ITODoaH+pRduOGTMYYq/8ae5f85GfwVG8S8Ke
pCC9uxouaYD+Ayi502YXkC/TeWIv7zDjcTFnKXFvmTb+YZwwnxLH1XC1wvLDSz48dns3zCIUkj8A
biaZjrp+9LXuBD9GAao0mpT373OXwuSoGmLakwxcKPTMNuV+RxwwtK+gSuWjaxdZw/8WE1+3Hb2W
Vpe3FAKa+Dwq57iNgxJ+zlkP62ONO8rVdXOaY75rr/yE/2VG/5F1ekOO1L6yadiH4tlYbAXJxx2r
Cmr47UQpqQ7BjK0xggNvMIIDawIBATCBlDCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2
BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMJ
2TIwCQYFKw4DAhoFAKCCAa8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMTQxMDE2MTQ1NTU2WjAjBgkqhkiG9w0BCQQxFgQUCwKE9nc+0oVTSYrliNrz6ezDaJkwgaUG
CSsGAQQBgjcQBDGBlzCBlDCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4x
KzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0
YXJ0Q29tIENsYXNzIDEgUHJpbWFyeSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgMJ2TIwgacGCyqG
SIb3DQEJEAILMYGXoIGUMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEr
MCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3Rh
cnRDb20gQ2xhc3MgMSBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAwnZMjANBgkqhkiG
9w0BAQEFAASCAQB4Ky8JigG0TlMFmqaEbgm2ArejGEVM+1uyn7m0izqZ8UV4ig23XAECiwPTFbGn
5m5KC/goNymHjkFXU//N+V3bD1v5fNLIXdb31H6B4/XgWfc+5ybN1dH1DStl3JorjMbbb1Tzhe9f
FC0tDwGQpH/PKyTU4yhZ6IMBmJBZYitUvRSGFrr+CJ27isNksQJSRwMMxYOw59PydqiTjzqLoUjF
rydys/O529yORjagD/gSHb3WSjZjeM7U7UrW7CZXPtpdsWaPk21TsVjMGRX0vj0e3rNEcHtmNV0U
XsykdBtMrhxTCG5zse0PJ9uaKDq4kZsZ6p4UyrkYADkGJxfzlG9eAAAAAAAA


--=-rMsDKpiGyfKabkwiRXEy--

