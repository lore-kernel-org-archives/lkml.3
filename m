Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaDNIAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:00:05 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:30187
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbaDNIAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:00:00 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F40C1145AS04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] input: cyapa: add sysfs interfaces supported for gen5
 trackpad device
Thread-Topic: [PATCH 6/6] input: cyapa: add sysfs interfaces supported for
 gen5 trackpad device
Thread-Index: Ac9XtsD3SWtrVWYrSdmTsHvCGfHVJQ==
Date: Mon, 14 Apr 2014 07:54:27 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C1145A@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F40C1145A@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.148]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F40C1145AS04MBX0101s04lo_
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
index 917eabe..4fb3677 100644
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

--_000_77BC725C9062764F874D79F51E1F1A8F40C1145AS04MBX0101s04lo_
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
AAADAPE/BAgAAAsAQDoBAAAAAwD9P6gDAAACAQswAQAAABAAAAD10kEL6dJDTYbrdOrzP+JmAwAX
AAEAAABAADkAgHsmwrZXzwFAAAgw8UxwwrZXzwELACkAAAAAAAsAIwAAAAAAHwAAgIYDAgAAAAAA
wAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAAAQAAABoAAAB6
AGgALQBDAE4ALAAgAGUAbgAtAFUAUwAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAABoUAAAAA
AAAfADcAAQAAAKQAAABbAFAAQQBUAEMASAAgADYALwA2AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBh
AHAAYQA6ACAAYQBkAGQAIABzAHkAcwBmAHMAIABpAG4AdABlAHIAZgBhAGMAZQBzACAAcwB1AHAA
cABvAHIAdABlAGQAIABmAG8AcgAgAGcAZQBuADUAIAB0AHIAYQBjAGsAcABhAGQAIABkAGUAdgBp
AGMAZQAAAB8APQABAAAAAgAAAAAAAAADADYAAAAAAAIBcQABAAAAFgAAAAHPV7bA90lra1VmK0nZ
k7B7whnx1SUAAB8AcAABAAAApAAAAFsAUABBAFQAQwBIACAANgAvADYAXQAgAGkAbgBwAHUAdAA6
ACAAYwB5AGEAcABhADoAIABhAGQAZAAgAHMAeQBzAGYAcwAgAGkAbgB0AGUAcgBmAGEAYwBlAHMA
IABzAHUAcABwAG8AcgB0AGUAZAAgAGYAbwByACAAZwBlAG4ANQAgAHQAcgBhAGMAawBwAGEAZAAg
AGQAZQB2AGkAYwBlAAAAHwA1EAEAAACEAAAAPAA3ADcAQgBDADcAMgA1AEMAOQAwADYAMgA3ADYA
NABGADgANwA0AEQANwA5AEYANQAxAEUAMQBGADEAQQA4AEYANAAwAEMAMQAxADQANQBBAEAAUwAw
ADQALQBNAEIAWAAwADEALQAwADEALgBzADAANAAuAGwAbwBjAGEAbAA+AAAAAwDeP59OAAALAACA
CCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAGFAAAA
AAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEAAAAAAAADAIAQ/////wUAAIADIAYAAAAAAMAA
AAAAAABGAAAAAAKBAAAAAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAByBAAAAAAAAQAAH
MLu6esG2V88BCwACAAEAAAADACYAAAAAAAIBEDABAAAARgAAAAAAAACxH6E5MCBRRp20pXDe0J/U
BwB3vHJckGJ2T4dNefUeHxqPAAAAmTwbAAC6pz7uy9f3QKN27zX8YVmJABiD/MMqAAAAAB8A+j8B
AAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAAwAJWQEAAAADAACACCAGAAAAAADAAAAAAAAARgAA
AAAQhQAAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBzAGEAdABp
AG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAC6AAAASQBJAD0AMAAxAEMA
RgA1ADcAQgA2AEMAMABGADcANAA5ADYAQgA2AEIANQA1ADYANgAyAEIANAA5AEQAOQA5ADMAQgAw
ADcAQgBDADIAMQA5AEYAMQBEADUAMgA1ADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMAaQBvAG4A
IAAxADQALgAzACAAKABCAHUAaQBsAGQAIAAxADcANAAuADAAKQAsACAAUwB0AGEAZwBlAD0ASAA0
AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAATgQAAAQAAAAMAAIADIAYAAAAAAMAAAAAAAABG
AAAAACOBAAD///9/AwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEIEAAAAAAAADAACAAyAGAAAAAADA
AAAAAAAARgAAAAARgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACSBAAAAAAAACwAAgAMg
BgAAAAAAwAAAAAAAAEYAAAAALIEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAApgQAAAAAA
AAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACqBAAAAAAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAA
J4EAAAEAAAACAAAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABKBAAABAAAAHwAAgAMgBgAA
AAAAwAAAAAAAAEYAAAAAIYEAAAEAAAACAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAAOB
AAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJoEAAAAAAAALAACACCAGAAAAAADAAAAAAAAA
RgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAACwAAgAggBgAAAAAA
wAAAAAAAAEYAAAAAgoUAAAAAAABAAACACCAGAAAAAADAAAAAAAAARgAAAAC/hQAA4OzGRrZXzwED
AA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQA
dABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwBy
AGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAHgAAAFsAMQAwAC4AMwAwAC4AMQAyAC4A
MQA0ADgAXQAAAAAAn8Y=

--_000_77BC725C9062764F874D79F51E1F1A8F40C1145AS04MBX0101s04lo_--
