Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaFFHbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:31:39 -0400
Received: from relay-s04-hub006.domainlocalhost.com ([74.115.207.217]:38435
	"EHLO relay-S04-HUB006.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbaFFH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:13 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C8E4S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 9/14] input: cyapa: add gen3 trackpad device read
 firmware image function supported
Thread-Topic: [PATCH v2 9/14] input: cyapa: add gen3 trackpad device read
 firmware image function supported
Thread-Index: Ac+BWOzJPIh1Vy0uRvy9B48DS0G8TQ==
Date: Fri, 6 Jun 2014 07:29:11 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C8E4@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C8E4@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8E4S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add read firmware image function supported for gen3 trackpad device,
which its function is supplied through cyapa core read_fw interface.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_g=
en3.c
index 9ffdbc1..e903e62 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -689,6 +689,35 @@ static int cyapa_gen3_write_fw_block(struct cyapa *cya=
pa,
        return ret;
 }

+/*
+ * A firmware block read command reads 16 bytes of data from flash startin=
g
+ * from a given address.  The 12-byte block read command has the format:
+ *   <0xff> <CMD> <Key> <Addr>
+ *
+ *  <0xff>  - every command starts with 0xff
+ *  <CMD>   - the read command value is 0x3c
+ *  <Key>   - read commands include an 8-byte key: { 00 01 02 03 04 05 06 =
07 }
+ *  <Addr>  - Memory address (16-bit, big-endian)
+ *
+ * The command is followed by an i2c block read to read the 16 bytes of da=
ta.
+ */
+static int cyapa_gen3_read_fw_bytes(struct cyapa *cyapa, u16 addr, u8 *dat=
a)
+{
+       int ret;
+       u8 cmd[] =3D { 0xff, 0x3c, 0, 1, 2, 3, 4, 5, 6, 7, addr >> 8, addr =
};
+
+       ret =3D cyapa_gen3_write_buffer(cyapa, cmd, sizeof(cmd));
+       if (ret)
+               return ret;
+
+       /* read data buffer starting from offset 16 */
+       ret =3D cyapa_i2c_reg_read_block(cyapa, 16, CYAPA_FW_READ_SIZE, dat=
a);
+       if (ret !=3D CYAPA_FW_READ_SIZE)
+               return (ret < 0) ? ret : -EIO;
+
+       return 0;
+}
+
 static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
                const struct firmware *fw)
 {
@@ -724,6 +753,47 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa=
,
        return 0;
 }

+/*
+ * Read the entire firmware image into ->read_fw_image.
+ * If the ->read_fw_image has already been allocated, then this function
+ * doesn't do anything and just returns 0.
+ * If an error occurs while reading the image, ->read_fw_image is freed, a=
nd
+ * the error is returned.
+ *
+ * The firmware is a fixed size (CYAPA_FW_SIZE), and is read out in
+ * fixed length (CYAPA_FW_READ_SIZE) chunks.
+ */
+static int cyapa_gen3_read_fw(struct cyapa *cyapa)
+{
+       int ret;
+       int addr;
+
+       ret =3D cyapa_gen3_bl_enter(cyapa);
+       if (ret)
+               goto err;
+
+       cyapa->read_fw_image =3D kmalloc(CYAPA_FW_SIZE, GFP_KERNEL);
+       if (!cyapa->read_fw_image) {
+               ret =3D -ENOMEM;
+               goto err;
+       }
+
+       for (addr =3D 0; addr < CYAPA_FW_SIZE; addr +=3D CYAPA_FW_READ_SIZE=
) {
+               ret =3D cyapa_gen3_read_fw_bytes(cyapa, CYAPA_FW_HDR_START =
+ addr,
+                                         &cyapa->read_fw_image[addr]);
+               if (ret) {
+                       kfree(cyapa->read_fw_image);
+                       cyapa->read_fw_image =3D NULL;
+                       break;
+               }
+       }
+
+err:
+       if (cyapa->read_fw_image)
+               cyapa->read_fw_image_size =3D CYAPA_FW_SIZE;
+       return ret;
+}
+
 static ssize_t cyapa_gen3_do_calibrate(struct device *dev,
                                     struct device_attribute *attr,
                                     const char *buf, size_t count)
@@ -1122,7 +1192,7 @@ const struct cyapa_dev_ops cyapa_gen3_ops =3D {
        cyapa_gen3_show_baseline,
        cyapa_gen3_do_calibrate,

-       NULL,
+       cyapa_gen3_read_fw,
        NULL,

        NULL,
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8E4S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
cABhADoAIABhAGQAZAAgAGcAZQBuADMAIAB0AHIAYQBjAGsAcABhAGQAIABkAGUAdgBpAGMAZQAg
AHIAZQBhAGQAIABmAGkAcgBtAHcAYQByAGUAIABpAG0AYQBnAGUAIABmAHUAbgBjAHQAaQBvAG4A
IABzAHUAcABwAG8AcgB0AGUAZAAAAB8APQABAAAAAgAAAAAAAAADADYAAAAAAAIBcQABAAAAFgAA
AAHPgVjsyTyIdVctLkb8vQePA0tBvE0AAB8AcAABAAAAvAAAAFsAUABBAFQAQwBIACAAdgAyACAA
OQAvADEANABdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAgAGEAZABkACAAZwBlAG4AMwAg
AHQAcgBhAGMAawBwAGEAZAAgAGQAZQB2AGkAYwBlACAAcgBlAGEAZAAgAGYAaQByAG0AdwBhAHIA
ZQAgAGkAbQBhAGcAZQAgAGYAdQBuAGMAdABpAG8AbgAgAHMAdQBwAHAAbwByAHQAZQBkAAAAHwA1
EAEAAACEAAAAPAA3ADcAQgBDADcAMgA1AEMAOQAwADYAMgA3ADYANABGADgANwA0AEQANwA5AEYA
NQAxAEUAMQBGADEAQQA4AEYANAA0ADAANgBDADgARQA0AEAAUwAwADQALQBNAEIAWAAwADEALQAw
ADEALgBzADAANAAuAGwAbwBjAGEAbAA+AAAAAwDeP59OAAALAACACCAGAAAAAADAAAAAAAAARgAA
AAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAGFAAAAAAAAAwAAgAMgBgAAAAAAwAAA
AAAAAEYAAAAAAYEAAAAAAAADAIAQ/////wUAAIADIAYAAAAAAMAAAAAAAABGAAAAAAKBAAAAAAAA
AAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAByBAAAAAAAAQAAHMJ1MOAJZgc8BCwACAAEAAAAD
ACYAAAAAAAIBEDABAAAARgAAAAAAAACxH6E5MCBRRp20pXDe0J/UBwB3vHJckGJ2T4dNefUeHxqP
AAAAmTwbAAC6pz7uy9f3QKN27zX8YVmJABiD/MNOAAAAAB8A+j8BAAAAFAAAAEQAdQBkAGwAZQB5
ACAARAB1AAAAAwAJWQEAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAQhQAAAAAAAB8AAIAfpOsz
qHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVABy
AGEAYwBrAGkAbgBnAEUAeAAAAAEAAAC6AAAASQBJAD0AMAAxAEMARgA4ADEANQA4AEUAQwBDADkA
MwBDADgAOAA3ADUANQA3ADIARAAyAEUANAA2AEYAQwBCAEQAMAA3ADgARgAwADMANABCADQAMQBC
AEMANABEADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMAaQBvAG4AIAAxADQALgAzACAAKABCAHUA
aQBsAGQAIAAxADcANAAuADAAKQAsACAAUwB0AGEAZwBlAD0ASAA0AAAAAAADAACAAyAGAAAAAADA
AAAAAAAARgAAAAATgQAAAQAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACOBAAD///9/AwAAgAMg
BgAAAAAAwAAAAAAAAEYAAAAAEIEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAARgQAAAAAA
AAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACSBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAA
LIEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAApgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAA
AABGAAAAACqBAAAAAAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJ4EAAAEAAAACAAAAAAAAAAMA
AIADIAYAAAAAAMAAAAAAAABGAAAAABKBAAABAAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAIYEA
AAEAAAACAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAAOBAAAAAAAACwAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAJoEAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAI
IAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAgoUAAAAA
AAADAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBh
AHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0A
bwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAHgAAAFsAMQAwAC4AMwAwAC4AMQAy
AC4AMQA0ADYAXQAAAAAAa9Q=

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8E4S04MBX0101s04lo_--
