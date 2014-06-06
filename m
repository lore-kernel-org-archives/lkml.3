Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaFFH3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:29:38 -0400
Received: from relay-s04-hub006.domainlocalhost.com ([74.115.207.217]:38475
	"EHLO relay-S04-HUB006.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655AbaFFH3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:32 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C900S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 12/14] input: cyapa: add gen5 trackpad device baseline
 and calibrate functions supported
Thread-Topic: [PATCH v2 12/14] input: cyapa: add gen5 trackpad device
 baseline and calibrate functions supported
Thread-Index: Ac+BWPBF0VbRyTtjQGKIPvEAgtYMhw==
Date: Fri, 6 Jun 2014 07:29:29 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C900@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C900@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C900S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add report baseline and force calibrate functions supported for gen5
trackpad device, which these functions are supplied through
cyapa core baseline and calibrate interfaces.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_g=
en5.c
index e720eed..3da6a91 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -1479,6 +1479,679 @@ static int cyapa_gen5_set_power_mode(struct cyapa *=
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
+       if (cyapa->state !=3D CYAPA_STATE_GEN5_APP)
+               return -EBUSY;
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
 static bool cyapa_gen5_sort_system_info_data(struct cyapa *cyapa,
                u8 *buf, int len)
 {
@@ -1867,8 +2540,8 @@ const struct cyapa_dev_ops cyapa_gen5_ops =3D {
        NULL,
        NULL,

-       NULL,
-       NULL,
+       cyapa_gen5_show_baseline,
+       cyapa_gen5_do_calibrate,

        NULL,
        NULL,
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C900S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAaAAAAegBoAC0AQwBOACwA
IABlAG4ALQBVAFMAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAADG
AAAAWwBQAEEAVABDAEgAIAB2ADIAIAAxADIALwAxADQAXQAgAGkAbgBwAHUAdAA6ACAAYwB5AGEA
cABhADoAIABhAGQAZAAgAGcAZQBuADUAIAB0AHIAYQBjAGsAcABhAGQAIABkAGUAdgBpAGMAZQAg
AGIAYQBzAGUAbABpAG4AZQAgAGEAbgBkACAAYwBhAGwAaQBiAHIAYQB0AGUAIABmAHUAbgBjAHQA
aQBvAG4AcwAgAHMAdQBwAHAAbwByAHQAZQBkAAAAAAAfAD0AAQAAAAIAAAAAAAAAAwA2AAAAAAAC
AXEAAQAAABYAAAABz4FY8EXRVtHJO2NAYog+8QCC1gyHAAAfAHAAAQAAAMYAAABbAFAAQQBUAEMA
SAAgAHYAMgAgADEAMgAvADEANABdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAgAGEAZABk
ACAAZwBlAG4ANQAgAHQAcgBhAGMAawBwAGEAZAAgAGQAZQB2AGkAYwBlACAAYgBhAHMAZQBsAGkA
bgBlACAAYQBuAGQAIABjAGEAbABpAGIAcgBhAHQAZQAgAGYAdQBuAGMAdABpAG8AbgBzACAAcwB1
AHAAcABvAHIAdABlAGQAAAAAAB8ANRABAAAAhAAAADwANwA3AEIAQwA3ADIANQBDADkAMAA2ADIA
NwA2ADQARgA4ADcANABEADcAOQBGADUAMQBFADEARgAxAEEAOABGADQANAAwADYAQwA5ADAAMABA
AFMAMAA0AC0ATQBCAFgAMAAxAC0AMAAxAC4AcwAwADQALgBsAG8AYwBhAGwAPgAAAAMA3j+fTgAA
CwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAA4UAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAB
hQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAAAGBAAAAAAAAAwCAEP////8FAACAAyAGAAAA
AADAAAAAAAAARgAAAAACgQAAAAAAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAcgQAAAAAA
AEAABzCjV6ALWYHPAQsAAgABAAAAAwAmAAAAAAACARAwAQAAAEYAAAAAAAAAsR+hOTAgUUadtKVw
3tCf1AcAd7xyXJBidk+HTXn1Hh8ajwAAAJk8GwAAuqc+7svX90Cjdu81/GFZiQAYg/zDUQAAAAAf
APo/AQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAAMACVkBAAAAAwAAgAggBgAAAAAAwAAAAAAA
AEYAAAAAEIUAAAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBh
AHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAAugAAAEkASQA9ADAA
MQBDAEYAOAAxADUAOABGADAANAA1AEQAMQA1ADYARAAxAEMAOQAzAEIANgAzADQAMAA2ADIAOAA4
ADMARQBGADEAMAAwADgAMgBEADYAMABDADgANwA7AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkA
bwBuACAAMQA0AC4AMwAgACgAQgB1AGkAbABkACAAMQA3ADQALgAwACkALAAgAFMAdABhAGcAZQA9
AEgANAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAE4EAAAEAAAADAACAAyAGAAAAAADAAAAA
AAAARgAAAAAjgQAA////fwMAAIADIAYAAAAAAMAAAAAAAABGAAAAABCBAAAAAAAAAwAAgAMgBgAA
AAAAwAAAAAAAAEYAAAAAEYEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAkgQAAAAAAAAsA
AIADIAYAAAAAAMAAAAAAAABGAAAAACyBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKYEA
AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAqgQAAAAAAAB8AAIADIAYAAAAAAMAAAAAAAABG
AAAAACeBAAABAAAAAgAAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAASgQAAAQAAAB8AAIAD
IAYAAAAAAMAAAAAAAABGAAAAACGBAAABAAAAAgAAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAA
AAADgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACaBAAAAAAAACwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAADoUAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAYhQAAAAAAAAsAAIAIIAYA
AAAAAMAAAAAAAABGAAAAAIKFAAAAAAAAAwANNP0/AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAg
AAAAeAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAAAAAfAACAhgMCAAAA
AADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAtAGkAcAAAAAAAAQAA
AB4AAABbADEAMAAuADMAMAAuADEAMgAuADEANAA2AF0AAAAAAG/W

--_000_77BC725C9062764F874D79F51E1F1A8F4406C900S04MBX0101s04lo_--
