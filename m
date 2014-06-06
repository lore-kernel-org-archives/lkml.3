Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaFFHbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:31:07 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:30930
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbaFFH30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:26 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C8F4S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 11/14] input: cyapa: add gen5 trackpad device firmware
 update function supported
Thread-Topic: [PATCH v2 11/14] input: cyapa: add gen5 trackpad device
 firmware update function supported
Thread-Index: Ac+BWO7LO16+BJiVSDqXQuKbd9VMpA==
Date: Fri, 6 Jun 2014 07:29:24 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C8F4@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C8F4@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8F4S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add firmware image update function supported for gen5 trackpad device,
which its function is supplied through cyapa core update_fw interface.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index 6b8441f..e484569 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -205,7 +205,7 @@ config MOUSE_BCM5974

 config MOUSE_CYAPA
        tristate "Cypress APA I2C Trackpad support"
-       depends on I2C
+       depends on I2C && CRC_ITU_T
        help
          This driver adds support for Cypress All Points Addressable (APA)
          I2C Trackpads, including the ones used in 2012 Samsung Chromebook=
s.
diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_g=
en5.c
index 00ca3a6..e720eed 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -18,6 +18,7 @@
 #include <linux/completion.h>
 #include <linux/slab.h>
 #include <linux/unaligned/access_ok.h>
+#include <linux/crc-itu-t.h>
 #include "cyapa.h"


@@ -856,6 +857,86 @@ out:
        return -EAGAIN;
 }

+static int cyapa_gen5_bl_initiate(struct cyapa *cyapa,
+               const struct firmware *fw)
+{
+       int ret =3D 0;
+       u16 length =3D 0;
+       u16 data_len =3D 0;
+       u16 meta_data_crc =3D 0;
+       u16 cmd_crc =3D 0;
+       u8 bl_gen5_activate[18 + CYAPA_TSG_FLASH_MAP_BLOCK_SIZE + 3];
+       int bl_gen5_activate_size =3D 0;
+       u8 resp_data[11];
+       int resp_len;
+       struct cyapa_tsg_bin_image *image;
+       int records_num;
+       u8 *data;
+
+       /* Try to dump all bufferred report data before send any command. *=
/
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       bl_gen5_activate_size =3D sizeof(bl_gen5_activate);
+       memset(bl_gen5_activate, 0, bl_gen5_activate_size);
+
+       /* Output Report Register Address[15:0] =3D 0004h */
+       bl_gen5_activate[0] =3D 0x04;
+       bl_gen5_activate[1] =3D 0x00;
+
+       /* totoal command length[15:0] */
+       length =3D bl_gen5_activate_size - 2;
+       put_unaligned_le16(length, &bl_gen5_activate[2]);
+       bl_gen5_activate[4] =3D 0x40;  /* Report ID =3D 40h */
+       bl_gen5_activate[5] =3D 0x00;  /* RSVD =3D 00h */
+
+       bl_gen5_activate[6] =3D GEN5_SOP_KEY;  /* SOP =3D 01h */
+       bl_gen5_activate[7] =3D 0x48;  /* Command Code =3D 48h */
+
+       /* 8 Key bytes and block size */
+       data_len =3D CYAPA_TSG_BL_KEY_SIZE + CYAPA_TSG_FLASH_MAP_BLOCK_SIZE=
;
+       /* Data Length[15:0] */
+       put_unaligned_le16(data_len, &bl_gen5_activate[8]);
+       bl_gen5_activate[10] =3D 0xa5;  /* Key Byte 0 */
+       bl_gen5_activate[11] =3D 0x01;
+       bl_gen5_activate[12] =3D 0x02;  /*     .      */
+       bl_gen5_activate[13] =3D 0x03;  /*     .      */
+       bl_gen5_activate[14] =3D 0xff;  /*     .      */
+       bl_gen5_activate[15] =3D 0xfe;
+       bl_gen5_activate[16] =3D 0xfd;
+       bl_gen5_activate[17] =3D 0x5a;  /* Key Byte 7 */
+
+       /* copy 60 bytes Meta Data Row Parameters */
+       image =3D (struct cyapa_tsg_bin_image *)fw->data;
+       records_num =3D (fw->size - sizeof(struct cyapa_tsg_bin_image_head)=
) /
+                               sizeof(struct cyapa_tsg_bin_image_data_reco=
rd);
+       /* APP_INTEGRITY row is always the last row block */
+       data =3D image->records[records_num - 1].record_data;
+       memcpy(&bl_gen5_activate[18], data, CYAPA_TSG_FLASH_MAP_METADATA_SI=
ZE);
+
+       meta_data_crc =3D crc_itu_t(0xffff, &bl_gen5_activate[18],
+                               CYAPA_TSG_FLASH_MAP_METADATA_SIZE);
+       /* Meta Data CRC[15:0] */
+       put_unaligned_le16(meta_data_crc,
+               &bl_gen5_activate[18 + CYAPA_TSG_FLASH_MAP_METADATA_SIZE]);
+
+       cmd_crc =3D crc_itu_t(0xffff, &bl_gen5_activate[6], 4 + data_len);
+       put_unaligned_le16(cmd_crc,
+               &bl_gen5_activate[bl_gen5_activate_size - 3]);  /* CRC[15:0=
] */
+       bl_gen5_activate[bl_gen5_activate_size - 1] =3D GEN5_EOP_KEY;
+
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       bl_gen5_activate, sizeof(bl_gen5_activate),
+                       resp_data, &resp_len, 12000,
+                       cyapa_gen5_sort_tsg_pip_bl_resp_data);
+       if (ret || resp_len !=3D GEN5_BL_INITIATE_RESP_LEN ||
+                       resp_data[2] !=3D GEN5_BL_RESP_REPORT_ID ||
+                       !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+               return (ret < 0) ? ret : -EAGAIN;
+
+       return 0;
+}
+
 bool cyapa_gen5_sort_bl_exit_data(struct cyapa *cyapa, u8 *buf, int len)
 {
        if (buf =3D=3D NULL || len < GEN5_RESP_LENGTH_SIZE)
@@ -902,6 +983,216 @@ static int cyapa_gen5_bl_exit(struct cyapa *cyapa)
        return -EAGAIN;
 }

+static int cyapa_gen5_bl_enter(struct cyapa *cyapa)
+{
+       int ret;
+       u8 cmd[] =3D { 0x04, 0x00, 0x05, 0x00, 0x2F, 0x00, 0x01 };
+       u8 resp_data[2];
+       int resp_len;
+
+       if (cyapa->input) {
+               cyapa_disable_irq(cyapa);
+               input_unregister_device(cyapa->input);
+               cyapa->input =3D NULL;
+       }
+       cyapa_enable_irq(cyapa);
+
+       ret =3D cyapa_poll_state(cyapa, 500);
+       if (ret < 0)
+               return ret;
+       if (cyapa->gen !=3D CYAPA_GEN5)
+               return -EINVAL;
+
+       /* Already in Gen5 BL. Skipping exit. */
+       if (cyapa->state =3D=3D CYAPA_STATE_GEN5_BL)
+               return 0;
+
+       if (cyapa->state !=3D CYAPA_STATE_GEN5_APP)
+               return -EAGAIN;
+
+       /* Try to dump all bufferred report data before send any command. *=
/
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       /*
+        * send bootloader enter command to trackpad device,
+        * after enter bootloader, the response data is two bytes of 0x00 0=
x00.
+        */
+       resp_len =3D sizeof(resp_data);
+       memset(resp_data, 0, resp_len);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, sizeof(cmd),
+                       resp_data, &resp_len,
+                       5000, cyapa_gen5_sort_application_launch_data);
+       if (ret || resp_data[0] !=3D 0x00 || resp_data[1] !=3D 0x00)
+               return (ret < 0) ? ret : -EAGAIN;
+
+       cyapa->state =3D CYAPA_STATE_GEN5_BL;
+       return 0;
+}
+
+static int cyapa_gen5_check_fw(struct cyapa *cyapa, const struct firmware =
*fw)
+{
+       int i;
+       struct cyapa_tsg_bin_image *image;
+       int flash_records_count;
+       u16 expected_app_crc;
+       u16 expected_app_integrity_crc;
+       u16 app_crc =3D 0;
+       u16 app_integrity_crc =3D 0;
+       u16 row_num;
+       u8 *data;
+       u32 app_start;
+       u16 app_len;
+       u32 img_start;
+       u16 img_len;
+       int record_index;
+       struct device *dev =3D &cyapa->client->dev;
+
+       image =3D (struct cyapa_tsg_bin_image *)fw->data;
+       flash_records_count =3D (fw->size -
+                       sizeof(struct cyapa_tsg_bin_image_head)) /
+                       sizeof(struct cyapa_tsg_bin_image_data_record);
+
+       /* APP_INTEGRITY row is always the last row block,
+        * and the row id must be 0x01ff */
+       row_num =3D get_unaligned_be16(
+                       &image->records[flash_records_count - 1].row_number=
);
+       if (&image->records[flash_records_count - 1].flash_array_id !=3D 0x=
00 &&
+                       row_num !=3D 0x01ff) {
+               dev_err(dev, "%s: invaid app_integrity data.\n", __func__);
+               return -EINVAL;
+       }
+       data =3D image->records[flash_records_count - 1].record_data;
+       app_start =3D get_unaligned_le32(&data[4]);
+       app_len =3D get_unaligned_le16(&data[8]);
+       expected_app_crc =3D get_unaligned_le16(&data[10]);
+       img_start =3D get_unaligned_le32(&data[16]);
+       img_len =3D get_unaligned_le16(&data[20]);
+       expected_app_integrity_crc =3D get_unaligned_le16(&data[60]);
+
+       if ((app_start + app_len + img_start + img_len) %
+                       CYAPA_TSG_FW_ROW_SIZE) {
+               dev_err(dev, "%s: invaid image alignment.\n", __func__);
+               return -EINVAL;
+       }
+
+       /* verify app_integrity crc */
+       app_integrity_crc =3D crc_itu_t(0xffff, data,
+                       CYAPA_TSG_APP_INTEGRITY_SIZE);
+       if (app_integrity_crc !=3D expected_app_integrity_crc) {
+               dev_err(dev, "%s: invaid app_integrity crc.\n", __func__);
+               return -EINVAL;
+       }
+
+       /*
+        * verify application image CRC
+        */
+       record_index =3D app_start / CYAPA_TSG_FW_ROW_SIZE -
+                               CYAPA_TSG_IMG_START_ROW_NUM;
+       data =3D (u8 *)&image->records[record_index].record_data;
+       app_crc =3D crc_itu_t(0xffff, data, CYAPA_TSG_FW_ROW_SIZE);
+       for (i =3D 1; i < (app_len / CYAPA_TSG_FW_ROW_SIZE); i++) {
+               data =3D (u8 *)&image->records[++record_index].record_data;
+               app_crc =3D crc_itu_t(app_crc, data, CYAPA_TSG_FW_ROW_SIZE)=
;
+       }
+
+       if (app_crc !=3D expected_app_crc) {
+               dev_err(dev, "%s: invaid firmware app crc check.\n", __func=
__);
+               return -EINVAL;
+       }
+
+       return 0;
+}
+
+static int cyapa_gen5_write_fw_block(struct cyapa *cyapa,
+               struct cyapa_tsg_bin_image_data_record *flash_record)
+{
+       u8 flash_array_id;
+       u16 flash_row_id;
+       u16 record_len;
+       u8 *record_data;
+       u8 cmd[144];  /* 13 + 128+ 3 */
+       u16 cmd_len;
+       u16 data_len;
+       u16 crc;
+       u8 resp_data[11];
+       int resp_len;
+       int ret;
+
+       flash_array_id =3D flash_record->flash_array_id;
+       flash_row_id =3D get_unaligned_be16(&flash_record->row_number);
+       record_len =3D get_unaligned_be16(&flash_record->record_len);
+       record_data =3D flash_record->record_data;
+
+       cmd_len =3D sizeof(cmd) - 2; /* not include 2 bytes regisetr addres=
s. */
+       memset(cmd, 0, cmd_len + 2);
+       cmd[0] =3D 0x04;  /* register address */
+       cmd[1] =3D 0x00;
+
+       put_unaligned_le16(cmd_len, &cmd[2]);
+       cmd[4] =3D 0x40;  /* report id 40h */
+       cmd[5] =3D 0x00;
+
+       cmd[6] =3D GEN5_SOP_KEY;  /* SOP =3D 01h */
+       cmd[7] =3D 0x39;  /* command code =3D 39h */
+       /* 1 (Flash Array ID) + 2 (Flash Row ID) + 128 (flash data) */
+       data_len =3D 3 + record_len;
+       put_unaligned_le16(data_len, &cmd[8]);
+       cmd[10] =3D flash_array_id;  /* Flash Array ID =3D 00h */
+       put_unaligned_le16(flash_row_id, &cmd[11]);
+
+       memcpy(&cmd[13], record_data, record_len);
+       crc =3D crc_itu_t(0xffff, &cmd[6], 4 + data_len);
+       put_unaligned_le16(crc, &cmd[2 + cmd_len - 3]);
+       cmd[2 + cmd_len - 1] =3D GEN5_EOP_KEY;
+
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, sizeof(cmd),
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_bl_resp_data);
+       if (ret || resp_len !=3D GEN5_BL_BLOCK_WRITE_RESP_LEN ||
+                       resp_data[2] !=3D GEN5_BL_RESP_REPORT_ID ||
+                       !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+               return ret < 0 ? ret : -EAGAIN;
+
+       return 0;
+}
+
+static int cyapa_gen5_do_fw_update(struct cyapa *cyapa,
+               const struct firmware *fw)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       struct cyapa_tsg_bin_image *image =3D
+               (struct cyapa_tsg_bin_image *)fw->data;
+       struct cyapa_tsg_bin_image_data_record *flash_record;
+       int flash_records_count;
+       int i;
+       int ret;
+
+       /* Try to dump all bufferred data if exists before send commands. *=
/
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       flash_records_count =3D
+               (fw->size - sizeof(struct cyapa_tsg_bin_image_head)) /
+                       sizeof(struct cyapa_tsg_bin_image_data_record);
+       /*
+        * the last flash row 0x01ff has been written through bl_initiate
+        *  command, so DO NOT write flash 0x01ff to trackpad device.
+        */
+       for (i =3D 0; i < (flash_records_count - 1); i++) {
+               flash_record =3D &image->records[i];
+               ret =3D cyapa_gen5_write_fw_block(cyapa, flash_record);
+               if (ret) {
+                       dev_err(dev, "%s: Gen5 FW update aborted, %d\n",
+                               __func__, ret);
+                       return ret;
+               }
+       }
+
+       return 0;
+}
+
 static int cyapa_gen5_change_power_state(struct cyapa *cyapa, u8 power_sta=
te)
 {
        int ret;
@@ -1568,11 +1859,11 @@ static void cyapa_gen5_irq_handler(struct cyapa *cy=
apa)
 }

 const struct cyapa_dev_ops cyapa_gen5_ops =3D {
+       cyapa_gen5_check_fw,
+       cyapa_gen5_bl_enter,
        NULL,
-       NULL,
-       NULL,
-       NULL,
-       NULL,
+       cyapa_gen5_bl_initiate,
+       cyapa_gen5_do_fw_update,
        NULL,
        NULL,

This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8F4S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
rmW8dm8AMZgZMSKv0WT8MP+fcLD/VICzKKq2reZWK4Ck+Z8Sb3DwsJgZvaICIJ0P+68bZeBrUsGi
HpgZPBFbUf/j8KIWpmZ1I6gl7xDED8Uf/8Yvxz/ISMG/wsOIRsmvUg+fUxPDb8g5zv+7iFRo8QD/
HdHxsF5CCNII0G4QH3CucP+vwB3gaCDSEQvBViGucIFQ0CBDeXD3oyiPoYhg0fCwc3Vi7lBkiICH
IP9DQJzgViFW8FugaCCIgG7Qv4FQcKFlMK6QVjBxwEk98MeIYIZ45SFlaXZvYdSBd28x5VB1wHD8
MOCAoQFk/1ng2pGE4nDy90II4ZUgHeD71gH3MGxuEFug/DCLUYTgM9IIjXZ9fahw3tAAAAAfAEIA
AQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAB8AZQABAAAAIgAAAGQAdQBkAGwAQABjAHkAcABy
AGUAcwBzAC4AYwBvAG0AAAAAAB8AZAABAAAACgAAAFMATQBUAFAAAAAAAAIBQQABAAAAWAAAAAAA
AACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwAZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBk
AGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAfAAJdAQAAACIAAABkAHUAZABsAEAAYwB5AHAA
cgBlAHMAcwAuAGMAbwBtAAAAAAAfAOVfAQAAACoAAABzAGkAcAA6AGQAdQBkAGwAQABjAHkAcABy
AGUAcwBzAC4AYwBvAG0AAAAAAB8AGgwBAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAHwAfDAEA
AAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBN
AFQAUAAAAAAAAgEZDAEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkA
IABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8AAV0B
AAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8A+D8BAAAAFAAAAEQA
dQBkAGwAZQB5ACAARAB1AAAAHwAjQAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBj
AG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAABYAAAAAAAAAIErH6S+oxAZ
nW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBw
AHIAZQBzAHMALgBjAG8AbQAAAB8ACV0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4A
YwBvAG0AAAAAAB8AMUABAAAAAgAAAAAAAAALAEA6AQAAAB8AMEABAAAAAgAAAAAAAAAfABoAAQAA
ABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8ECAAACwBAOgEAAAADAP0/qAMAAAIBCzABAAAA
EAAAAJmSkDTt+IBCvwNpSk2KmscDABcAAQAAAEAAOQAAoi8KWYHPAUAACDCxAYcKWYHPAQsAKQAA
AAAACwAjAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4A
ZwB1AGEAZwBlAAAAAAABAAAAGgAAAHoAaAAtAEMATgAsACAAZQBuAC0AVQBTAAAAAAALAACACCAG
AAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAtgAAAFsAUABBAFQAQwBIACAAdgAyACAA
MQAxAC8AMQA0AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6ACAAYQBkAGQAIABnAGUAbgA1
ACAAdAByAGEAYwBrAHAAYQBkACAAZABlAHYAaQBjAGUAIABmAGkAcgBtAHcAYQByAGUAIAB1AHAA
ZABhAHQAZQAgAGYAdQBuAGMAdABpAG8AbgAgAHMAdQBwAHAAbwByAHQAZQBkAAAAAAAfAD0AAQAA
AAIAAAAAAAAAAwA2AAAAAAACAXEAAQAAABYAAAABz4FY7ss7Xr4EmJVIOpdC4pt31UykAAAfAHAA
AQAAALYAAABbAFAAQQBUAEMASAAgAHYAMgAgADEAMQAvADEANABdACAAaQBuAHAAdQB0ADoAIABj
AHkAYQBwAGEAOgAgAGEAZABkACAAZwBlAG4ANQAgAHQAcgBhAGMAawBwAGEAZAAgAGQAZQB2AGkA
YwBlACAAZgBpAHIAbQB3AGEAcgBlACAAdQBwAGQAYQB0AGUAIABmAHUAbgBjAHQAaQBvAG4AIABz
AHUAcABwAG8AcgB0AGUAZAAAAAAAHwA1EAEAAACEAAAAPAA3ADcAQgBDADcAMgA1AEMAOQAwADYA
MgA3ADYANABGADgANwA0AEQANwA5AEYANQAxAEUAMQBGADEAQQA4AEYANAA0ADAANgBDADgARgA0
AEAAUwAwADQALQBNAEIAWAAwADEALQAwADEALgBzADAANAAuAGwAbwBjAGEAbAA+AAAAAwDeP59O
AAALAACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAA
AAGFAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEAAAAAAAADAIAQ/////wUAAIADIAYA
AAAAAMAAAAAAAABGAAAAAAKBAAAAAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAByBAAAA
AAAAQAAHMAT+HglZgc8BCwACAAEAAAADACYAAAAAAAIBEDABAAAARgAAAAAAAACxH6E5MCBRRp20
pXDe0J/UBwB3vHJckGJ2T4dNefUeHxqPAAAAmTwbAAC6pz7uy9f3QKN27zX8YVmJABiD/MNQAAAA
AB8A+j8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAAwAJWQEAAAADAACACCAGAAAAAADAAAAA
AAAARgAAAAAQhQAAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBz
AGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAC6AAAASQBJAD0A
MAAxAEMARgA4ADEANQA4AEUARQBDAEIAMwBCADUARQBCAEUAMAA0ADkAOAA5ADUANAA4ADMAQQA5
ADcANAAyAEUAMgA5AEIANwA3AEQANQA0AEMAQQA0ADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMA
aQBvAG4AIAAxADQALgAzACAAKABCAHUAaQBsAGQAIAAxADcANAAuADAAKQAsACAAUwB0AGEAZwBl
AD0ASAA0AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAATgQAAAQAAAAMAAIADIAYAAAAAAMAA
AAAAAABGAAAAACOBAAD///9/AwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEIEAAAAAAAADAACAAyAG
AAAAAADAAAAAAAAARgAAAAARgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACSBAAAAAAAA
CwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAALIEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAp
gQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACqBAAAAAAAAHwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAJ4EAAAEAAAACAAAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABKBAAABAAAAHwAA
gAMgBgAAAAAAwAAAAAAAAEYAAAAAIYEAAAEAAAACAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABG
AAAAAAOBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJoEAAAAAAAALAACACCAGAAAAAADA
AAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAACwAAgAgg
BgAAAAAAwAAAAAAAAEYAAAAAgoUAAAAAAAADAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAA
ACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIA
AAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAAB
AAAAHgAAAFsAMQAwAC4AMwAwAC4AMQAyAC4AMQA0ADYAXQAAAAAALFE=

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8F4S04MBX0101s04lo_--
