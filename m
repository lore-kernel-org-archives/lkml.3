Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaDPIls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:41:48 -0400
Received: from relay-s04-hub005.domainlocalhost.com ([74.115.207.216]:52444
	"EHLO relay-S04-HUB005.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754958AbaDPIln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:41:43 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F40C140C1S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "David Solda" <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] input: cyapa: add sysfs interfaces supported for gen5
 trackpad device
Thread-Topic: [PATCH 6/6] input: cyapa: add sysfs interfaces supported for
 gen5 trackpad device
Thread-Index: Ac9XtsD3SWtrVWYrSdmTsHvCGfHVJQBmMt6Q
Date: Wed, 16 Apr 2014 08:41:29 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C140C1@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F40C140C1@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.153]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F40C140C1S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add sysfs interfaces for gen5 trackpad devices that required in production,
including read and update firmware image, report baselines, sensors calibra=
te,
read product id, read firmware version.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index effa9c5..8653ffd 100644
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
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 66cb5cc..63a2c79 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -29,6 +29,8 @@
 #include <linux/uaccess.h>
 #include <linux/unaligned/access_ok.h>
 #include <linux/pm_runtime.h>
+#include <linux/crc-ccitt.h>
+#include <linux/crc-itu-t.h>


 /* APA trackpad firmware generation */
@@ -2364,6 +2366,86 @@ static int cyapa_gen5_state_parse(struct cyapa *cyap=
a, u8 *reg_data, int len)
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
@@ -2410,6 +2492,373 @@ static int cyapa_gen5_bl_exit(struct cyapa *cyapa)
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
+static int cyapa_gen5_read_fw_bytes(struct cyapa *cyapa, u16 row_num, u8 *=
data)
+{
+       int ret;
+       u8 cmd[16];
+       size_t cmd_len;
+       u8 resp_data[CYAPA_TSG_FW_ROW_SIZE / 2 + GEN5_MIN_BL_RESP_LENGTH];
+       int resp_len;
+       u16 offset;
+       u16 cmd_crc;
+       struct cyapa_tsg_bin_image_data_record *fw_img_record;
+
+       fw_img_record =3D (struct cyapa_tsg_bin_image_data_record *)data;
+
+       cmd[0] =3D 0x04;  /* register address */
+       cmd[1] =3D 0x00;
+       cmd[2] =3D 0x0e;
+       cmd[3] =3D 0x00;
+       cmd[4] =3D 0x40;  /* report id 40h */
+       cmd[5] =3D 0x00;
+       cmd[6] =3D GEN5_SOP_KEY;
+       cmd[7] =3D 0x3d;  /* read application image command code */
+       cmd[8] =3D 0x03;
+       cmd[9] =3D 0x00;
+       offset =3D row_num * CYAPA_TSG_FW_ROW_SIZE -
+                       CYAPA_TSG_START_OF_APPLICATION;
+       put_unaligned_le16(offset, &cmd[10]);
+       cmd[12] =3D CYAPA_TSG_IMG_READ_SIZE;
+       cmd_crc =3D crc_itu_t(0xffff, &cmd[6], 7);
+       put_unaligned_le16(cmd_crc, &cmd[13]);  /* CRC[15:0] */
+       cmd[15] =3D GEN5_EOP_KEY;  /* EOP =3D 17h */
+       cmd_len =3D 16;
+
+       resp_len =3D CYAPA_TSG_IMG_READ_SIZE + GEN5_MIN_BL_RESP_LENGTH;
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, cmd_len,
+                       resp_data, &resp_len,
+                       50, cyapa_gen5_sort_tsg_pip_bl_resp_data);
+       if (resp_len !=3D (CYAPA_TSG_IMG_READ_SIZE + GEN5_MIN_BL_RESP_LENGT=
H) ||
+                       ret || resp_data[2] !=3D GEN5_BL_RESP_REPORT_ID ||
+                       !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+               return (ret < 0) ? ret : -EAGAIN;
+
+       /* copy first 64 bytes in the row. */
+       memcpy(&fw_img_record->record_data[0], &resp_data[8],
+                       CYAPA_TSG_IMG_READ_SIZE);
+
+       if (row_num =3D=3D CYAPA_TSG_IMG_APP_INTEGRITY_ROW_NUM) {
+               /* last row's rest 64 bytes are bootloader metadata,
+                * it's not allowed to be read out, will respond with error=
. */
+               memset(&fw_img_record->record_data[CYAPA_TSG_IMG_READ_SIZE]=
,
+                       0, CYAPA_TSG_IMG_READ_SIZE);
+               goto skip_last_row;
+       }
+
+       /* read next 64 bytes in the row. */
+       offset =3D offset + CYAPA_TSG_IMG_READ_SIZE;
+       put_unaligned_le16(offset, &cmd[10]);
+       cmd_crc =3D crc_itu_t(0xffff, &cmd[6], 7);
+       put_unaligned_le16(cmd_crc, &cmd[13]);  /* CRC[15:0] */
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, cmd_len,
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_bl_resp_data);
+       if (resp_len !=3D (CYAPA_TSG_IMG_READ_SIZE + GEN5_MIN_BL_RESP_LENGT=
H) ||
+                       ret || resp_data[2] !=3D GEN5_BL_RESP_REPORT_ID ||
+                       !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+               return (ret < 0) ? ret : -EAGAIN;
+
+       /* copy last 64 bytes in the row. */
+       memcpy(&fw_img_record->record_data[CYAPA_TSG_IMG_READ_SIZE],
+               &resp_data[8], CYAPA_TSG_IMG_READ_SIZE);
+
+skip_last_row:
+       fw_img_record->flash_array_id =3D 0;
+       put_unaligned_be16(row_num, &fw_img_record->row_number);
+       put_unaligned_be16(CYAPA_TSG_FW_ROW_SIZE, &fw_img_record->record_le=
n);
+
+       return 0;
+}
+
+static int cyapa_gen5_read_fw(struct cyapa *cyapa)
+{
+       int ret;
+       int fw_img_head_size;
+       int fw_img_record_size;
+       int row_index;
+       int array_index;
+       u32 img_start;
+       u16 img_len;
+       u16 img_start_row;
+       u16 img_end_row;
+       struct cyapa_tsg_bin_image_data_record app_integrity;
+       u8 *record_data;
+
+       if (cyapa->read_fw_image)
+               return 0;
+
+       ret =3D cyapa_gen5_bl_enter(cyapa);
+       if (ret)
+               goto err;
+
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       fw_img_head_size =3D sizeof(struct cyapa_tsg_bin_image_head);
+       fw_img_record_size =3D sizeof(struct cyapa_tsg_bin_image_data_recor=
d);
+
+       /* Read app integrity block data. */
+       row_index =3D CYAPA_TSG_IMG_APP_INTEGRITY_ROW_NUM;
+       ret =3D cyapa_gen5_read_fw_bytes(cyapa, row_index, (u8 *)&app_integ=
rity);
+       if (ret)
+               goto err;
+       img_start =3D get_unaligned_le32(&app_integrity.record_data[16]);
+       img_len =3D get_unaligned_le16(&app_integrity.record_data[20]);
+       if ((img_start + img_len) % CYAPA_TSG_FW_ROW_SIZE)
+               goto err;
+       img_start_row =3D img_start / CYAPA_TSG_FW_ROW_SIZE;
+       img_end_row =3D (img_start + img_len) / CYAPA_TSG_FW_ROW_SIZE - 1;
+
+       /* allocate memory for image. */
+       cyapa->read_fw_image_size =3D fw_img_head_size +
+               (img_end_row -  img_start_row + 2) * fw_img_record_size;
+       cyapa->read_fw_image =3D kmalloc(cyapa->read_fw_image_size, GFP_KER=
NEL);
+       if (!cyapa->read_fw_image) {
+               ret =3D -ENOMEM;
+               goto err;
+       }
+
+       /* set image head data. */
+       memcpy(cyapa->read_fw_image, &cyapa->fw_img_head, fw_img_head_size)=
;
+
+       /* read image blocks. */
+       for (row_index =3D img_start_row, array_index =3D 0;
+                       row_index <=3D img_end_row;
+                       row_index++, array_index++) {
+               record_data =3D &cyapa->read_fw_image[fw_img_head_size +
+                               array_index * fw_img_record_size];
+               ret =3D cyapa_gen5_read_fw_bytes(cyapa, row_index, record_d=
ata);
+               if (ret)
+                       goto err;
+       }
+
+       /* append last app integrity block data. */
+       record_data =3D &cyapa->read_fw_image[fw_img_head_size +
+                               array_index * fw_img_record_size];
+       memcpy(record_data, &app_integrity, fw_img_record_size);
+
+err:
+       if (ret) {
+               kfree(cyapa->read_fw_image);
+               cyapa->read_fw_image =3D NULL;
+               cyapa->read_fw_image_size =3D 0;
+       }
+
+       cyapa_detect_async(cyapa, 0);
+       return ret;
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
 static int cyapa_gen5_sleep_time_check(u16 sleep_time)
 {
        if (sleep_time > 1000)
@@ -2694,6 +3143,763 @@ static int cyapa_gen5_set_power_mode(struct cyapa *=
cyapa,
        return ret;
 }

+static int cyapa_gen5_resume_scanning(struct cyapa *cyapa)
+{
+       u8 cmd[7] =3D { 0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x04 };
+       u8 resp_data[6];
+       int resp_len;
+       int ret;
+
+       /* Try to dump all bufferred data before doing command. */
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       resp_len =3D 6;
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, 7,
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+       if (ret || resp_data[2] !=3D GEN5_APP_RESP_REPORT_ID ||
+                       resp_data[3] !=3D GEN5_RESP_RSVD_KEY ||
+                       GET_GEN5_CMD_CODE(resp_data[4]) !=3D 0x04)
+               return -EINVAL;
+
+       /* Try to dump all bufferred data when resuming scanning. */
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       return 0;
+}
+
+static int cyapa_gen5_suspend_scanning(struct cyapa *cyapa)
+{
+       u8 cmd[7] =3D { 0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x03 };
+       u8 resp_data[6];
+       int resp_len;
+       int ret;
+
+       /* Try to dump all bufferred data before doing command. */
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       resp_len =3D 6;
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, 7,
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+       if (ret || resp_data[2] !=3D GEN5_APP_RESP_REPORT_ID ||
+                       resp_data[3] !=3D GEN5_RESP_RSVD_KEY ||
+                       GET_GEN5_CMD_CODE(resp_data[4]) !=3D 0x03)
+               return -EINVAL;
+
+       /* Try to dump all bufferred data when suspending scanning. */
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       return 0;
+}
+
+static int cyapa_gen5_calibrate_pwcs(struct cyapa *cyapa,
+               u8 calibrate_sensing_mode_type)
+{
+       int ret;
+       u8 cmd[8];
+       u8 resp_data[6];
+       int resp_len;
+
+       /* Try to dump all bufferred data before doing command. */
+       cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+       cmd[0] =3D 0x04;
+       cmd[1] =3D 0x00;
+       cmd[2] =3D 0x06;
+       cmd[3] =3D 0x00;
+       cmd[4] =3D GEN5_APP_CMD_REPORT_ID;
+       cmd[5] =3D 0x00;
+       cmd[6] =3D GEN5_CMD_CALIBRATE;
+       cmd[7] =3D calibrate_sensing_mode_type;
+       resp_len =3D sizeof(resp_data);
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, sizeof(cmd),
+                       resp_data, &resp_len,
+                       5000, cyapa_gen5_sort_tsg_pip_app_resp_data);
+       if (ret || resp_data[2] !=3D GEN5_APP_RESP_REPORT_ID ||
+                       GET_GEN5_CMD_CODE(resp_data[4]) !=3D GEN5_CMD_CALIB=
RATE ||
+                       !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+               return ret < 0 ? ret : -EAGAIN;
+
+       return 0;
+}
+
+static ssize_t cyapa_gen5_do_calibrate(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       int ret, calibrate_ret;
+
+       /* 1. suspend Scanning*/
+       ret =3D cyapa_gen5_suspend_scanning(cyapa);
+       if (ret)
+               return ret;
+
+       /* 2. do mutual capacitance fine calibrate. */
+       calibrate_ret =3D cyapa_gen5_calibrate_pwcs(cyapa,
+                               CYAPA_SENSING_MODE_MUTUAL_CAP_FINE);
+       if (calibrate_ret)
+               goto resume_scanning;
+
+       /* 3. do self capacitance calibrate. */
+       calibrate_ret =3D cyapa_gen5_calibrate_pwcs(cyapa,
+                               CYAPA_SENSING_MODE_SELF_CAP);
+       if (calibrate_ret)
+               goto resume_scanning;
+
+resume_scanning:
+       /* 4. resume Scanning*/
+       ret =3D cyapa_gen5_resume_scanning(cyapa);
+       if (ret || calibrate_ret)
+               return ret ? ret : calibrate_ret;
+
+       return count;
+}
+
+static s32 two_complement_to_s32(s32 value, int num_bits)
+{
+       if (value >> (num_bits - 1))
+               value |=3D  -1 << num_bits;
+       return value;
+}
+
+static s32 cyapa_parse_structure_data(u8 data_format, u8 *buf, int buf_len=
)
+{
+       int data_size;
+       bool big_endian;
+       bool unsigned_type;
+       s32 value;
+
+       data_size =3D (data_format & 0x07);
+       big_endian =3D ((data_format & 0x10) =3D=3D 0x00);
+       unsigned_type =3D ((data_format & 0x20) =3D=3D 0x00);
+
+       if (buf_len < data_size)
+               return 0;
+
+       switch (data_size) {
+       case 1:
+               value  =3D buf[0];
+               break;
+       case 2:
+               if (big_endian)
+                       value =3D get_unaligned_be16(buf);
+               else
+                       value =3D get_unaligned_le16(buf);
+               break;
+       case 4:
+               if (big_endian)
+                       value =3D get_unaligned_be32(buf);
+               else
+                       value =3D get_unaligned_le32(buf);
+               break;
+       default:
+               /* should not happen, just as default case here. */
+               value =3D 0;
+               break;
+       }
+
+       if (!unsigned_type)
+               value =3D two_complement_to_s32(value, data_size * 8);
+
+       return value;
+}
+
+
+/*
+ * Read all the global mutual or self idac data or mutual or self local PW=
C
+ * data based on the @idac_data_type.
+ * If the input value of @data_size is 0, then means read global mutual or
+ * self idac data. For read global mutual idac data, @idac_max, @idac_min =
and
+ * @idac_ave are in order used to return the max value of global mutual id=
ac
+ * data, the min value of global mutual idac and the average value of the
+ * global mutual idac data. For read global self idac data, @idac_max is u=
sed
+ * to return the global self cap idac data in Rx direction, @idac_min is u=
sed
+ * to return the global self cap idac data in Tx direction. @idac_ave is n=
ot
+ * used.
+ * If the input value of @data_size is not 0, than means read the mutual o=
r
+ * self local PWC data. The @idac_max, @idac_min and @idac_ave are used to
+ * return the max, min and average value of the mutual or self local PWC d=
ata.
+ * Note, in order to raed mutual local PWC data, must read invoke this fun=
ction
+ * to read the mutual global idac data firstly to set the correct Rx numbe=
r
+ * value, otherwise, the read mutual idac and PWC data may not correct.
+ */
+static int cyapa_gen5_read_idac_data(struct cyapa *cyapa,
+               u8 cmd_code, u8 idac_data_type, int *data_size,
+               int *idac_max, int *idac_min, int *idac_ave)
+{
+       int ret;
+       int i;
+       u8 cmd[12];
+       u8 resp_data[256];
+       int resp_len;
+       int read_len;
+       int value;
+       u16 offset;
+       int read_elements;
+       bool read_global_idac;
+       int sum, count, max_element_cnt;
+       int tmp_max, tmp_min, tmp_ave, tmp_sum, tmp_count, tmp_max_elements=
;
+       int electrodes_rx;
+
+       if (cmd_code !=3D GEN5_CMD_RETRIEVE_DATA_STRUCTURE ||
+               (idac_data_type !=3D GEN5_RETRIEVE_MUTUAL_PWC_DATA &&
+               idac_data_type !=3D GEN5_RETRIEVE_SELF_CAP_PWC_DATA) ||
+               !data_size || !idac_max || !idac_min || !idac_ave)
+               return -EINVAL;
+
+       *idac_max =3D INT_MIN;
+       *idac_min =3D INT_MAX;
+       sum =3D count =3D tmp_count =3D 0;
+       electrodes_rx =3D 0;
+       tmp_max_elements =3D 0;
+       if (*data_size =3D=3D 0) {
+               /* Read global idac values firstly.
+                * Currently, no idac data exceed 4 bytes. */
+               read_global_idac =3D true;
+               offset =3D 0;
+               *data_size =3D 4;
+
+               if (idac_data_type =3D=3D GEN5_RETRIEVE_MUTUAL_PWC_DATA) {
+                       if (cyapa->electrodes_rx =3D=3D 0) {
+                               if (cyapa->electrodes_y > cyapa->electrodes=
_x) {
+                                       electrodes_rx =3D cyapa->electrodes=
_y;
+                                       tmp_max_elements =3D cyapa->electro=
des_x;
+                               } else {
+                                       electrodes_rx =3D cyapa->electrodes=
_x;
+                                       tmp_max_elements =3D cyapa->electro=
des_y;
+                               }
+                       } else {
+                               electrodes_rx =3D cyapa->electrodes_rx;
+                               tmp_max_elements =3D 0;  /* disable Rx dete=
ct. */
+                       }
+                       max_element_cnt =3D ((electrodes_rx + 7) / 8) * 8;
+                       tmp_max =3D INT_MIN;
+                       tmp_min =3D INT_MAX;
+                       tmp_ave =3D tmp_sum =3D tmp_count =3D 0;
+               } else
+                       max_element_cnt =3D 2;
+       } else {
+               read_global_idac =3D false;
+               if (*data_size > 4)
+                       *data_size =3D 4;
+               /* calculate the start offset in bytes of local PWC data. *=
/
+               if (idac_data_type =3D=3D GEN5_RETRIEVE_MUTUAL_PWC_DATA) {
+                       offset =3D ((cyapa->electrodes_rx + 7) / 8) * 8
+                                               * (*data_size);
+                       if (cyapa->electrodes_rx =3D=3D cyapa->electrodes_x=
)
+                               tmp_count =3D cyapa->electrodes_y;
+                       else
+                               tmp_count =3D cyapa->electrodes_x;
+                       max_element_cnt =3D ((cyapa->electrodes_rx + 7) / 8=
) *
+                                               8 * tmp_count;
+               } else if (idac_data_type =3D=3D GEN5_RETRIEVE_SELF_CAP_PWC=
_DATA) {
+                       offset =3D 2;
+                       max_element_cnt =3D cyapa->electrodes_x +
+                                               cyapa->electrodes_y;
+               }
+       }
+
+       do {
+               read_elements =3D (256 - 10) / (*data_size);
+               read_elements =3D min(read_elements, max_element_cnt - coun=
t);
+               read_len =3D read_elements * (*data_size);
+
+               cmd[0] =3D 0x04;
+               cmd[1] =3D 0x00;
+               cmd[2] =3D 0x0a;
+               cmd[3] =3D 0x00;
+               cmd[4] =3D GEN5_APP_CMD_REPORT_ID;
+               cmd[5] =3D 0x00;
+               cmd[6] =3D cmd_code;
+               put_unaligned_le16(offset, &cmd[7]); /* Read Offset[15:0] *=
/
+               put_unaligned_le16(read_len, &cmd[9]); /* Read Length[15:0]=
 */
+               cmd[11] =3D idac_data_type;
+               resp_len =3D 10 + read_len;
+               ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                               cmd, 12,
+                               resp_data, &resp_len,
+                               500, cyapa_gen5_sort_tsg_pip_app_resp_data)=
;
+               if (ret || resp_len < 10 || resp_data[2] !=3D
+                                       GEN5_APP_RESP_REPORT_ID ||
+                               GET_GEN5_CMD_CODE(resp_data[4]) !=3D cmd_co=
de ||
+                               !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]) ||
+                               resp_data[6] !=3D idac_data_type)
+                       return (ret < 0) ? ret : -EAGAIN;
+               read_len =3D get_unaligned_le16(&resp_data[7]);
+               if (read_len =3D=3D 0)
+                       break;
+
+               *data_size =3D (resp_data[9] & GEN5_PWC_DATA_ELEMENT_SIZE_M=
ASK);
+               if (read_len < *data_size)
+                       return -EINVAL;
+
+               if (read_global_idac &&
+                       idac_data_type =3D=3D GEN5_RETRIEVE_SELF_CAP_PWC_DA=
TA) {
+                       /* Rx's self global idac data. */
+                       *idac_max =3D cyapa_parse_structure_data(
+                                       resp_data[9], &resp_data[10],
+                                       *data_size);
+                       /* Tx's self global idac data. */
+                       *idac_min =3D cyapa_parse_structure_data(
+                                       resp_data[9],
+                                       &resp_data[10 + *data_size],
+                                       *data_size);
+                       break;
+               }
+
+               /* read mutual global idac or local mutual/self PWC data. *=
/
+               offset +=3D read_len;
+               for (i =3D 10; i < (read_len + 10); i +=3D *data_size) {
+                       value =3D cyapa_parse_structure_data(resp_data[9],
+                                       &resp_data[i], *data_size);
+                       *idac_min =3D min(value, *idac_min);
+                       *idac_max =3D max(value, *idac_max);
+
+                       if (idac_data_type =3D=3D GEN5_RETRIEVE_MUTUAL_PWC_=
DATA &&
+                               tmp_count < tmp_max_elements &&
+                               read_global_idac) {
+                               tmp_min =3D min(value, tmp_min);
+                               tmp_max =3D max(value, tmp_max);
+                               tmp_sum +=3D value;
+                               tmp_count++;
+                       }
+
+                       sum +=3D value;
+                       count++;
+
+                       if (count >=3D max_element_cnt)
+                               goto out;
+               }
+       } while (true);
+
+out:
+       *idac_ave =3D count ? (sum / count) : 0;
+
+       if (read_global_idac &&
+               idac_data_type =3D=3D GEN5_RETRIEVE_MUTUAL_PWC_DATA) {
+               if (tmp_count =3D=3D 0)
+                       return 0;
+               /* algorithm to detect electrodes_rx value. */
+               tmp_ave =3D tmp_sum / tmp_count;
+               tmp_count =3D tmp_ave * 15 / 100;
+               if (abs(tmp_ave - *idac_ave) > tmp_count ||
+                       (abs(tmp_ave - *idac_min) > (tmp_count * 2) &&
+                               *idac_min < tmp_min) ||
+                       (abs(*idac_max - tmp_ave) > (tmp_count * 2) &&
+                               *idac_max > tmp_max)) {
+                       /* overcount the mutual global idac values. */
+                       cyapa->electrodes_rx =3D tmp_max_elements;
+                       *idac_min =3D tmp_min;
+                       *idac_max =3D tmp_max;
+                       *idac_ave =3D tmp_ave;
+               } else
+                       cyapa->electrodes_rx =3D electrodes_rx;
+       }
+
+       return 0;
+}
+
+static int cyapa_gen5_read_mutual_idac_data(struct cyapa *cyapa,
+       int *gidac_mutual_max, int *gidac_mutual_min, int *gidac_mutual_ave=
,
+       int *lidac_mutual_max, int *lidac_mutual_min, int *lidac_mutual_ave=
)
+{
+       int ret;
+       int data_size;
+
+       *gidac_mutual_max =3D *gidac_mutual_min =3D *gidac_mutual_ave =3D 0=
;
+       *lidac_mutual_max =3D *lidac_mutual_min =3D *lidac_mutual_ave =3D 0=
;
+
+       data_size =3D 0;
+       ret =3D cyapa_gen5_read_idac_data(cyapa,
+               GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+               GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+               &data_size,
+               gidac_mutual_max, gidac_mutual_min, gidac_mutual_ave);
+       if (ret)
+               return ret;
+
+       ret =3D cyapa_gen5_read_idac_data(cyapa,
+               GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+               GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+               &data_size,
+               lidac_mutual_max, lidac_mutual_min, lidac_mutual_ave);
+       return ret;
+}
+
+static int cyapa_gen5_read_self_idac_data(struct cyapa *cyapa,
+               int *gidac_self_rx, int *gidac_self_tx,
+               int *lidac_self_max, int *lidac_self_min, int *lidac_self_a=
ve)
+{
+       int ret;
+       int data_size;
+
+       *gidac_self_rx =3D *gidac_self_tx =3D 0;
+       *lidac_self_max =3D *lidac_self_min =3D *lidac_self_ave =3D 0;
+
+       data_size =3D 0;
+       ret =3D cyapa_gen5_read_idac_data(cyapa,
+               GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+               GEN5_RETRIEVE_SELF_CAP_PWC_DATA,
+               &data_size,
+               lidac_self_max, lidac_self_min, lidac_self_ave);
+       if (ret)
+               return ret;
+       *gidac_self_rx =3D *lidac_self_max;
+       *gidac_self_tx =3D *lidac_self_min;
+
+       ret =3D cyapa_gen5_read_idac_data(cyapa,
+               GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+               GEN5_RETRIEVE_SELF_CAP_PWC_DATA,
+               &data_size,
+               lidac_self_max, lidac_self_min, lidac_self_ave);
+       return ret;
+}
+
+static ssize_t cyapa_gen5_execute_panel_scan(struct cyapa *cyapa)
+{
+       int ret;
+       u8 cmd[7];
+       u8 resp_data[6];
+       int resp_len;
+
+       cmd[0] =3D 0x04;
+       cmd[1] =3D 0x00;
+       cmd[2] =3D 0x05;
+       cmd[3] =3D 0x00;
+       cmd[4] =3D GEN5_APP_CMD_REPORT_ID;
+       cmd[5] =3D 0x00;
+       cmd[6] =3D GEN5_CMD_EXECUTE_PANEL_SCAN;  /* command code */
+       resp_len =3D 6;
+       ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, 7,
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+       if (ret || resp_len !=3D 6 ||
+                       resp_data[2] !=3D GEN5_APP_RESP_REPORT_ID ||
+                       GET_GEN5_CMD_CODE(resp_data[4]) !=3D
+                               GEN5_CMD_EXECUTE_PANEL_SCAN ||
+                       !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5])) {
+               cyapa_gen5_resume_scanning(cyapa);
+               return (ret < 0) ? ret : -EAGAIN;
+       }
+
+       return 0;
+}
+
+static int cyapa_gen5_read_panel_scan_raw_data(struct cyapa *cyapa,
+               u8 cmd_code, u8 raw_data_type, int raw_data_max_num,
+               int *raw_data_max, int *raw_data_min, int *raw_data_ave,
+               u8 *buffer)
+{
+       int ret;
+       int i;
+       u8 cmd[12];
+       u8 resp_data[256];  /* max bytes can transfer one time. */
+       int resp_len;
+       int read_elements;
+       int read_len;
+       u16 offset;
+       s32 value;
+       int sum, count;
+       int data_size;
+       s32 *intp;
+
+       if (cmd_code !=3D GEN5_CMD_RETRIEVE_PANEL_SCAN ||
+               (raw_data_type > GEN5_PANEL_SCAN_SELF_DIFFCOUNT) ||
+               !raw_data_max || !raw_data_min || !raw_data_ave)
+               return -EINVAL;
+
+       intp =3D (s32 *)buffer;
+       *raw_data_max =3D INT_MIN;
+       *raw_data_min =3D INT_MAX;
+       sum =3D count =3D 0;
+       offset =3D 0;
+       read_elements =3D (256 - 10) / 4;  /* currently, max element size i=
s 4. */
+       read_len =3D read_elements * 4;
+       do {
+               cmd[0] =3D 0x04;
+               cmd[1] =3D 0x00;
+               cmd[2] =3D 0x0a;
+               cmd[3] =3D 0x00;
+               cmd[4] =3D GEN5_APP_CMD_REPORT_ID;
+               cmd[5] =3D 0x00;
+               cmd[6] =3D cmd_code;  /* command code */
+               put_unaligned_le16(offset, &cmd[7]);
+               put_unaligned_le16(read_elements, &cmd[9]);
+               cmd[11] =3D raw_data_type;
+               resp_len =3D 10 + read_len;
+
+               ret =3D cyapa_i2c_pip_cmd_irq_sync(cyapa,
+                       cmd, 12,
+                       resp_data, &resp_len,
+                       500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+               if (ret || resp_len < 10 ||
+                               resp_data[2] !=3D GEN5_APP_RESP_REPORT_ID |=
|
+                               (resp_data[4] & 0x7f) !=3D cmd_code ||
+                               !GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]) ||
+                               resp_data[6] !=3D raw_data_type)
+                       return (ret < 0) ? ret : -EAGAIN;
+
+               read_elements =3D get_unaligned_le16(&resp_data[7]);
+               if (read_elements =3D=3D 0)
+                       break;
+
+               data_size =3D (resp_data[9] & GEN5_PWC_DATA_ELEMENT_SIZE_MA=
SK);
+               offset +=3D read_elements;
+               if (read_elements) {
+                       for (i =3D 10;
+                            i < (read_elements * data_size + 10);
+                            i +=3D data_size) {
+                               value =3D cyapa_parse_structure_data(resp_d=
ata[9],
+                                               &resp_data[i], data_size);
+                               *raw_data_min =3D min(value, *raw_data_min)=
;
+                               *raw_data_max =3D max(value, *raw_data_max)=
;
+
+                               if (intp)
+                                       put_unaligned_le32(value, &intp[cou=
nt]);
+
+                               sum +=3D value;
+                               count++;
+
+                       }
+               }
+
+               if (count >=3D raw_data_max_num)
+                       break;
+
+               read_elements =3D (sizeof(resp_data) - 10) / data_size;
+               read_len =3D read_elements * data_size;
+       } while (true);
+
+       *raw_data_ave =3D count ? (sum / count) : 0;
+
+       return 0;
+}
+
+static ssize_t cyapa_gen5_show_baseline(struct device *dev,
+                                  struct device_attribute *attr, char *buf=
)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       int ret, err;
+       int gidac_mutual_max, gidac_mutual_min, gidac_mutual_ave;
+       int lidac_mutual_max, lidac_mutual_min, lidac_mutual_ave;
+       int gidac_self_rx, gidac_self_tx;
+       int lidac_self_max, lidac_self_min, lidac_self_ave;
+       int raw_cap_mutual_max, raw_cap_mutual_min, raw_cap_mutual_ave;
+       int raw_cap_self_max, raw_cap_self_min, raw_cap_self_ave;
+       int mutual_diffdata_max, mutual_diffdata_min, mutual_diffdata_ave;
+       int self_diffdata_max, self_diffdata_min, self_diffdata_ave;
+       int mutual_baseline_max, mutual_baseline_min, mutual_baseline_ave;
+       int self_baseline_max, self_baseline_min, self_baseline_ave;
+
+       /* 1. suspend Scanning*/
+       ret =3D cyapa_gen5_suspend_scanning(cyapa);
+       if (ret)
+               return ret;
+
+       /* 2.  read global and local mutual IDAC data. */
+       gidac_self_rx =3D gidac_self_tx =3D 0;
+       err =3D cyapa_gen5_read_mutual_idac_data(cyapa,
+                               &gidac_mutual_max, &gidac_mutual_min,
+                               &gidac_mutual_ave, &lidac_mutual_max,
+                               &lidac_mutual_min, &lidac_mutual_ave);
+       if (err)
+               goto resume_scanning;
+
+       /* 3.  read global and local self IDAC data. */
+       err =3D cyapa_gen5_read_self_idac_data(cyapa,
+                               &gidac_self_rx, &gidac_self_tx,
+                               &lidac_self_max, &lidac_self_min,
+                               &lidac_self_ave);
+       if (err)
+               goto resume_scanning;
+
+       /* 4. execuate panel scan. It must be executed before read data. */
+       err =3D cyapa_gen5_execute_panel_scan(cyapa);
+       if (err)
+               goto resume_scanning;
+
+       /* 5. retrive panel scan, mutual cap raw data. */
+       err =3D cyapa_gen5_read_panel_scan_raw_data(cyapa,
+                               GEN5_CMD_RETRIEVE_PANEL_SCAN,
+                               GEN5_PANEL_SCAN_MUTUAL_RAW_DATA,
+                               cyapa->electrodes_x * cyapa->electrodes_y,
+                               &raw_cap_mutual_max, &raw_cap_mutual_min,
+                               &raw_cap_mutual_ave,
+                               NULL);
+       if (err)
+               goto resume_scanning;
+
+       /* 6. retrive panel scan, self cap raw data. */
+       err =3D cyapa_gen5_read_panel_scan_raw_data(cyapa,
+                               GEN5_CMD_RETRIEVE_PANEL_SCAN,
+                               GEN5_PANEL_SCAN_SELF_RAW_DATA,
+                               cyapa->electrodes_x + cyapa->electrodes_y,
+                               &raw_cap_self_max, &raw_cap_self_min,
+                               &raw_cap_self_ave,
+                               NULL);
+       if (err)
+               goto resume_scanning;
+
+       /* 7. retrive panel scan, mutual cap diffcount raw data. */
+       err =3D cyapa_gen5_read_panel_scan_raw_data(cyapa,
+                               GEN5_CMD_RETRIEVE_PANEL_SCAN,
+                               GEN5_PANEL_SCAN_MUTUAL_DIFFCOUNT,
+                               cyapa->electrodes_x * cyapa->electrodes_y,
+                               &mutual_diffdata_max, &mutual_diffdata_min,
+                               &mutual_diffdata_ave,
+                               NULL);
+       if (err)
+               goto resume_scanning;
+
+       /* 8. retrive panel scan, self cap diffcount raw data. */
+       err =3D cyapa_gen5_read_panel_scan_raw_data(cyapa,
+                               GEN5_CMD_RETRIEVE_PANEL_SCAN,
+                               GEN5_PANEL_SCAN_SELF_DIFFCOUNT,
+                               cyapa->electrodes_x + cyapa->electrodes_y,
+                               &self_diffdata_max, &self_diffdata_min,
+                               &self_diffdata_ave,
+                               NULL);
+       if (err)
+               goto resume_scanning;
+
+       /* 9. retrive panel scan, mutual cap baseline raw data. */
+       err =3D cyapa_gen5_read_panel_scan_raw_data(cyapa,
+                               GEN5_CMD_RETRIEVE_PANEL_SCAN,
+                               GEN5_PANEL_SCAN_MUTUAL_BASELINE,
+                               cyapa->electrodes_x * cyapa->electrodes_y,
+                               &mutual_baseline_max, &mutual_baseline_min,
+                               &mutual_baseline_ave,
+                               NULL);
+       if (err)
+               goto resume_scanning;
+
+       /* 10. retrive panel scan, self cap baseline raw data. */
+       err =3D cyapa_gen5_read_panel_scan_raw_data(cyapa,
+                               GEN5_CMD_RETRIEVE_PANEL_SCAN,
+                               GEN5_PANEL_SCAN_SELF_BASELINE,
+                               cyapa->electrodes_x + cyapa->electrodes_y,
+                               &self_baseline_max, &self_baseline_min,
+                               &self_baseline_ave,
+                               NULL);
+       if (err)
+               goto resume_scanning;
+
+resume_scanning:
+       /* 11. resume Scanning*/
+       ret =3D cyapa_gen5_resume_scanning(cyapa);
+       if (ret || err)
+               return ret ? ret : err;
+
+       /* 12. output data strings */
+       ret =3D scnprintf(buf, PAGE_SIZE, "%d %d %d %d %d %d %d %d %d %d %d=
 ",
+               gidac_mutual_min, gidac_mutual_max, gidac_mutual_ave,
+               lidac_mutual_min, lidac_mutual_max, lidac_mutual_ave,
+               gidac_self_rx, gidac_self_tx,
+               lidac_self_min, lidac_self_max, lidac_self_ave);
+       err =3D scnprintf(buf + ret, PAGE_SIZE - ret,
+               "%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
+               raw_cap_mutual_min, raw_cap_mutual_max, raw_cap_mutual_ave,
+               raw_cap_self_min, raw_cap_self_max, raw_cap_self_ave,
+               mutual_diffdata_min, mutual_diffdata_max, mutual_diffdata_a=
ve,
+               self_diffdata_min, self_diffdata_max, self_diffdata_ave,
+               mutual_baseline_min, mutual_baseline_max, mutual_baseline_a=
ve,
+               self_baseline_min, self_baseline_max, self_baseline_ave);
+       return ret + err;
+}
+
+static int cyapa_gen5_read_raw_data(struct cyapa *cyapa)
+{
+       int ret, err;
+       int raw_cap_mutual_max, raw_cap_mutual_min, raw_cap_mutual_ave;
+       int raw_cap_self_max, raw_cap_self_min, raw_cap_self_ave;
+       int offset;
+       int data_size, max, min, ave;
+       ktime_t time_mono;
+
+       offset =3D 0;
+       if (!cyapa->tp_raw_data)
+               return -ENOMEM;
+
+       /* 1. suspend Scanning.
+        * After suspend scanning, the raw data will not be updated,
+        * so the time of the raw data is before scanning suspended. */
+       time_mono =3D ktime_get();
+       ret =3D cyapa_gen5_suspend_scanning(cyapa);
+       if (ret)
+               return ret;
+
+       /* 2. get the correct electrodes_rx number. */
+       if (cyapa->electrodes_rx =3D=3D 0) {
+               /* Through the read global idac interface to get the Rx num=
ber.
+                * this value is useful to the raw data map.*/
+               data_size =3D 0;
+               err =3D cyapa_gen5_read_idac_data(cyapa,
+                               GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+                               GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+                               &data_size, &max, &min, &ave);
+               if (err || cyapa->electrodes_rx =3D=3D 0)
+                       goto resume_scanning;
+       }
+
+       /* 3. execuate panel scan. It must be executed before read data. */
+       err =3D cyapa_gen5_execute_panel_scan(cyapa);
+       if (err)
+               goto resume_scanning;
+
+       /* 4. retrive panel scan, mutual cap raw data. */
+       offset =3D GEN5_RAW_DATA_HEAD_SIZE;
+       err =3D cyapa_gen5_read_panel_scan_raw_data(cyapa,
+                               GEN5_CMD_RETRIEVE_PANEL_SCAN,
+                               GEN5_PANEL_SCAN_MUTUAL_DIFFCOUNT,
+                               cyapa->electrodes_x * cyapa->electrodes_y,
+                               &raw_cap_mutual_max, &raw_cap_mutual_min,
+                               &raw_cap_mutual_ave,
+                               cyapa->tp_raw_data + offset);
+       if (err)
+               goto resume_scanning;
+
+       offset +=3D sizeof(s32) * cyapa->electrodes_x * cyapa->electrodes_y=
;
+
+       /* 5. retrive panel scan, self cap raw data. */
+       err =3D cyapa_gen5_read_panel_scan_raw_data(cyapa,
+                               GEN5_CMD_RETRIEVE_PANEL_SCAN,
+                               GEN5_PANEL_SCAN_SELF_DIFFCOUNT,
+                               cyapa->electrodes_x + cyapa->electrodes_y,
+                               &raw_cap_self_max, &raw_cap_self_min,
+                               &raw_cap_self_ave,
+                               cyapa->tp_raw_data + offset);
+       if (err)
+               goto resume_scanning;
+
+       offset +=3D sizeof(s32) * (cyapa->electrodes_x + cyapa->electrodes_=
y);
+
+resume_scanning:
+       /* 6. resume Scanning*/
+       ret =3D cyapa_gen5_resume_scanning(cyapa);
+       if (ret || err)
+               return ret ? ret : err;
+
+       *((struct timeval *)&cyapa->tp_raw_data[0]) =3D
+                                               ktime_to_timeval(time_mono)=
;
+       cyapa->tp_raw_data[16] =3D (u8)cyapa->electrodes_x;
+       cyapa->tp_raw_data[17] =3D (u8)cyapa->electrodes_y;
+       cyapa->tp_raw_data[18] =3D (u8)cyapa->x_origin;
+       cyapa->tp_raw_data[19] =3D (u8)cyapa->y_origin;
+       cyapa->tp_raw_data[20] =3D (u8)sizeof(s32);
+       cyapa->tp_raw_data[21] =3D (u8)sizeof(s32);
+       cyapa->tp_raw_data[22] =3D (u8)cyapa->electrodes_rx;
+       cyapa->tp_raw_data[23] =3D 0;  /* reserved. */
+
+       cyapa->tp_raw_data_size =3D offset;
+       return 0;
+}
+
 static bool cyapa_gen5_sort_system_info_data(struct cyapa *cyapa,
                u8 *buf, int len)
 {
@@ -3050,19 +4256,19 @@ static int cyapa_check_is_operational(struct cyapa =
*cyapa)

        switch (cyapa->gen) {
        case CYAPA_GEN5:
-               cyapa->cyapa_check_fw =3D NULL;
-               cyapa->cyapa_bl_enter =3D NULL;
+               cyapa->cyapa_check_fw =3D cyapa_gen5_check_fw;
+               cyapa->cyapa_bl_enter =3D cyapa_gen5_bl_enter;
                cyapa->cyapa_bl_activate =3D NULL;
-               cyapa->cyapa_bl_initiate =3D NULL;
-               cyapa->cyapa_update_fw =3D NULL;
+               cyapa->cyapa_bl_initiate =3D cyapa_gen5_bl_initiate;
+               cyapa->cyapa_update_fw =3D cyapa_gen5_do_fw_update;
                cyapa->cyapa_bl_verify_app_integrity =3D NULL;
                cyapa->cyapa_bl_deactivate =3D NULL;
-               cyapa->cyapa_show_baseline =3D NULL;
-               cyapa->cyapa_calibrate_store =3D NULL;
+               cyapa->cyapa_show_baseline =3D cyapa_gen5_show_baseline;
+               cyapa->cyapa_calibrate_store =3D cyapa_gen5_do_calibrate;
                cyapa->cyapa_irq_handler =3D cyapa_gen5_irq_handler;
                cyapa->cyapa_set_power_mode =3D cyapa_gen5_set_power_mode;
-               cyapa->cyapa_read_fw =3D NULL;
-               cyapa->cyapa_read_raw_data =3D NULL;
+               cyapa->cyapa_read_fw =3D cyapa_gen5_read_fw;
+               cyapa->cyapa_read_raw_data =3D cyapa_gen5_read_raw_data;

                cyapa_enable_irq_save(cyapa);
                ret =3D cyapa_gen5_do_operational_check(cyapa);
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F40C140C1S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAFgAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBE
AHUAZABsAGUAeQAgAEQAdQAAAFMATQBUAFAAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMA
bwBtAAAAHwACXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwDl
XwEAAAAqAAAAcwBpAHAAOgBkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfABoM
AQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAB8AHwwBAAAAIgAAAGQAdQBkAGwAQABjAHkAcABy
AGUAcwBzAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAWAAAAAAA
AACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwAZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBk
AGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAfAAFdAQAAACIAAABkAHUAZABsAEAAYwB5AHAA
cgBlAHMAcwAuAGMAbwBtAAAAAAAfAPg/AQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAB8AI0AB
AAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AIkABAAAACgAAAFMA
TQBUAFAAAAAAAAIB+T8BAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwAZQB5
ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAfAAld
AQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfADFAAQAAAAIAAAAA
AAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAA
AAADAPE/BAgAAAsAQDoBAAAAAwD9P6gDAAACAQswAQAAABAAAACTicQWZstQSYhh/IKVTXhnAwAX
AAEAAABAADkAgAIFqU9ZzwFAAAgwz28vqU9ZzwELACkAAAAAAAsAIwAAAAAAHwAAgIYDAgAAAAAA
wAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAABoAAAB6
AGgALQBDAE4ALAAgAGUAbgAtAFUAUwAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAABoUAAAAA
AAAfADcAAQAAAKQAAABbAFAAQQBUAEMASAAgADYALwA2AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBh
AHAAYQA6ACAAYQBkAGQAIABzAHkAcwBmAHMAIABpAG4AdABlAHIAZgBhAGMAZQBzACAAcwB1AHAA
cABvAHIAdABlAGQAIABmAG8AcgAgAGcAZQBuADUAIAB0AHIAYQBjAGsAcABhAGQAIABkAGUAdgBp
AGMAZQAAAB8APQABAAAAAgAAAAAAAAADADYAAAAAAAMALgAAAAAAHwBCEAEAAAACAAAAAAAAAAIB
cQABAAAAGwAAAAHPV7bA90lra1VmK0nZk7B7whnx1SUAZjLekAAfAHAAAQAAAKQAAABbAFAAQQBU
AEMASAAgADYALwA2AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6ACAAYQBkAGQAIABzAHkA
cwBmAHMAIABpAG4AdABlAHIAZgBhAGMAZQBzACAAcwB1AHAAcABvAHIAdABlAGQAIABmAG8AcgAg
AGcAZQBuADUAIAB0AHIAYQBjAGsAcABhAGQAIABkAGUAdgBpAGMAZQAAAB8ANRABAAAAhAAAADwA
NwA3AEIAQwA3ADIANQBDADkAMAA2ADIANwA2ADQARgA4ADcANABEADcAOQBGADUAMQBFADEARgAx
AEEAOABGADQAMABDADEANAAwAEMAMQBAAFMAMAA0AC0ATQBCAFgAMAAxAC0AMAAxAC4AcwAwADQA
LgBsAG8AYwBhAGwAPgAAAB8AORABAAAAAgAAAAAAAAADAN4/n04AAAsAAIAIIAYAAAAAAMAAAAAA
AABGAAAAAAOFAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAAYUAAAAAAAADAACAAyAGAAAA
AADAAAAAAAAARgAAAAABgQAAAAAAAAMAgBD/////BQAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAoEA
AAAAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAHIEAAAAAAABAAAcwu6MfqE9ZzwELAAIA
AQAAAAMAJgAAAAAACwArAAAAAAACARAwAQAAAEYAAAAAAAAAsR+hOTAgUUadtKVw3tCf1AcAd7xy
XJBidk+HTXn1Hh8ajwAAAJk8GwAAuqc+7svX90Cjdu81/GFZiQAYg/zDMQAAAAAfAPo/AQAAABQA
AABEAHUAZABsAGUAeQAgAEQAdQAAAAMACVkBAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAEIUA
AAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBhAHQAaQBvAG4A
SQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAA3gAAAEkASQA9ADAAMQBDAEYANQA3
AEIANgBDADAARgA3ADQAOQA2AEIANgBCADUANQA2ADYAMgBCADQAOQBEADkAOQAzAEIAMAA3AEIA
QwAyADEAOQBGADEARAA1ADIANQAwADAANgA2ADMAMgBEAEUAOQAwADsAUwBCAEMASQBEAD0AMwA7
AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMwAgACgAQgB1AGkAbABkACAA
MQA3ADQALgAwACkALAAgAFMAdABhAGcAZQA9AEgANAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYA
AAAAE4EAAAEAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAjgQAA////fwMAAIADIAYAAAAAAMAA
AAAAAABGAAAAABCBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEYEAAAAAAAALAACAAyAG
AAAAAADAAAAAAAAARgAAAAAkgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACyBAAAAAAAA
AwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKYEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAq
gQAAAAAAAB8AAIADIAYAAAAAAMAAAAAAAABGAAAAACeBAAABAAAAAgAAAAAAAAADAACAAyAGAAAA
AADAAAAAAAAARgAAAAASgQAAAQAAAB8AAIADIAYAAAAAAMAAAAAAAABGAAAAACGBAAABAAAAAgAA
AAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAADgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABG
AAAAACaBAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAAAAADAACACCAGAAAAAADA
AAAAAAAARgAAAAAYhQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAIKFAAAAAAAAAwANNP0/
AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAgAAAAeAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBj
AGgAAAABAAAAAgAAAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcA
aQBuAGEAdABpAG4AZwAtAGkAcAAAAAAAAQAAAB4AAABbADEAMAAuADMAMAAuADEAMgAuADEANQAz
AF0AAAAAAG6y

--_000_77BC725C9062764F874D79F51E1F1A8F40C140C1S04MBX0101s04lo_--
