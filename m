Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaFFHak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:30:40 -0400
Received: from relay-s04-hub005.domainlocalhost.com ([74.115.207.216]:36889
	"EHLO relay-S04-HUB005.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752675AbaFFH3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:37 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C909S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 13/14] input: cyapa: add gen5 trackpad device read
 firmware image and raw data functions supported
Thread-Topic: [PATCH v2 13/14] input: cyapa: add gen5 trackpad device read
 firmware image and raw data functions supported
Thread-Index: Ac+BWPHqJ7lgZ+aqRHStI0k9C+jqmA==
Date: Fri, 6 Jun 2014 07:29:34 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C909@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C909@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C909S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add read firmware image function supported for gen5 trackpad device,
which its function is supplied through cyapa core read_fw interface.
Through this interface, upper layer application can read out, check
and backup the firmware image in trackpad device before updated
with new one when new firmware image may have problems.
Also add interfaces to report all sensor's raw data values to upper
layer, so it can help to find out the performance issue when users
reports problem, and also it's useful and required interface for
some customers that require sensors' raw data.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_g=
en5.c
index 3da6a91..817842e 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -1159,6 +1159,158 @@ static int cyapa_gen5_write_fw_block(struct cyapa *=
cyapa,
        return 0;
 }

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
+       memcpy(cyapa->read_fw_image, &gen5_fw_img_head, fw_img_head_size);
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
+       return ret;
+}
+
 static int cyapa_gen5_do_fw_update(struct cyapa *cyapa,
                const struct firmware *fw)
 {
@@ -2152,6 +2304,109 @@ resume_scanning:
        return ret + err;
 }

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
+       if (!cyapa->tp_raw_data) {
+               if (cyapa->state !=3D CYAPA_STATE_GEN5_APP ||
+                       !cyapa->electrodes_x || !cyapa->electrodes_y)
+                       return  -EINVAL;
+
+               cyapa->tp_raw_data_size =3D sizeof(s32) * (cyapa->electrode=
s_x *
+                       cyapa->electrodes_y + cyapa->electrodes_x +
+                       cyapa->electrodes_y) + GEN5_RAW_DATA_HEAD_SIZE;
+               /* This buffer will be hold after used until the driver is
+                * unloaded, the purpose of it is to improve the performace
+                * to avoid frequently allocate and release the buffer. */
+               cyapa->tp_raw_data =3D
+                       kmalloc(cyapa->tp_raw_data_size, GFP_KERNEL);
+               if (!cyapa->tp_raw_data)
+                       return -ENOMEM;
+               memset(cyapa->tp_raw_data, 0, cyapa->tp_raw_data_size);
+       }
+
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
@@ -2543,8 +2798,8 @@ const struct cyapa_dev_ops cyapa_gen5_ops =3D {
        cyapa_gen5_show_baseline,
        cyapa_gen5_do_calibrate,

-       NULL,
-       NULL,
+       cyapa_gen5_read_fw,
+       cyapa_gen5_read_raw_data,

        cyapa_gen5_get_private_size,
        cyapa_gen5_private_init,
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C909S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEA
AABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQ
AAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8AAV0BAAAAIgAAAGQAdQBkAGwA
QABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8A+D8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1
AAAAHwAjQAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAiQAEA
AAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1
AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8A
bQAAAB8ACV0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AMUAB
AAAAAgAAAAAAAAALAEA6AQAAAB8AMEABAAAAAgAAAAAAAAAfABoAAQAAABIAAABJAFAATQAuAE4A
bwB0AGUAAAAAAAMA8T8ECAAACwBAOgEAAAADAP0/qAMAAAIBCzABAAAAEAAAALfbIuHLI9VJjcBT
vq6H0ZcDABcAAQAAAEAAOQAAgyUQWYHPAUAACDDQ45sQWYHPAQsAKQAAAAAACwAjAAAAAAAfAACA
hgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAAB
AAAAGgAAAHoAaAAtAEMATgAsACAAZQBuAC0AVQBTAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAA
AAAGhQAAAAAAAB8ANwABAAAA2gAAAFsAUABBAFQAQwBIACAAdgAyACAAMQAzAC8AMQA0AF0AIABp
AG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6ACAAYQBkAGQAIABnAGUAbgA1ACAAdAByAGEAYwBrAHAA
YQBkACAAZABlAHYAaQBjAGUAIAByAGUAYQBkACAAZgBpAHIAbQB3AGEAcgBlACAAaQBtAGEAZwBl
ACAAYQBuAGQAIAByAGEAdwAgAGQAYQB0AGEAIABmAHUAbgBjAHQAaQBvAG4AcwAgAHMAdQBwAHAA
bwByAHQAZQBkAAAAAAAfAD0AAQAAAAIAAAAAAAAAAwA2AAAAAAACAXEAAQAAABYAAAABz4FY8eon
uWBn5qpEdK0jST0L6OqYAAAfAHAAAQAAANoAAABbAFAAQQBUAEMASAAgAHYAMgAgADEAMwAvADEA
NABdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAgAGEAZABkACAAZwBlAG4ANQAgAHQAcgBh
AGMAawBwAGEAZAAgAGQAZQB2AGkAYwBlACAAcgBlAGEAZAAgAGYAaQByAG0AdwBhAHIAZQAgAGkA
bQBhAGcAZQAgAGEAbgBkACAAcgBhAHcAIABkAGEAdABhACAAZgB1AG4AYwB0AGkAbwBuAHMAIABz
AHUAcABwAG8AcgB0AGUAZAAAAAAAHwA1EAEAAACEAAAAPAA3ADcAQgBDADcAMgA1AEMAOQAwADYA
MgA3ADYANABGADgANwA0AEQANwA5AEYANQAxAEUAMQBGADEAQQA4AEYANAA0ADAANgBDADkAMAA5
AEAAUwAwADQALQBNAEIAWAAwADEALQAwADEALgBzADAANAAuAGwAbwBjAGEAbAA+AAAAAwDeP59O
AAALAACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAA
AAGFAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEAAAAAAAADAIAQ/////wUAAIADIAYA
AAAAAMAAAAAAAABGAAAAAAKBAAAAAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAByBAAAA
AAAAQAAHMEyDtQ5Zgc8BCwACAAEAAAADACYAAAAAAAIBEDABAAAARgAAAAAAAACxH6E5MCBRRp20
pXDe0J/UBwB3vHJckGJ2T4dNefUeHxqPAAAAmTwbAAC6pz7uy9f3QKN27zX8YVmJABiD/MNSAAAA
AB8A+j8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAAwAJWQEAAAADAACACCAGAAAAAADAAAAA
AAAARgAAAAAQhQAAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBz
AGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAC6AAAASQBJAD0A
MAAxAEMARgA4ADEANQA4AEYAMQBFAEEAMgA3AEIAOQA2ADAANgA3AEUANgBBAEEANAA0ADcANABB
AEQAMgAzADQAOQAzAEQAMABCAEUAOABFAEEAOQA4ADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMA
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
AAAAHgAAAFsAMQAwAC4AMwAwAC4AMQAyAC4AMQA0ADYAXQAAAAAAXBk=

--_000_77BC725C9062764F874D79F51E1F1A8F4406C909S04MBX0101s04lo_--
