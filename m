Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3A3NDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:03:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab3A3NDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:03:45 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Kurachkin Michail <Michail.Kurachkin@promwad.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re: TDM bus support in Linux Kernel [PATCH]
Date: Wed, 30 Jan 2013 14:03:50 +0100
Message-ID: <3071962.fRDCyxVGjS@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 12:37:25 Kurachkin Michail wrote:
> Hi Greg,
> 
> I followed your recommendations and created a diff using Linux 3.8-rc5 sources. Please review it and give your comments.

Part #2

+/**
+ * slic controls over ioctl
+ * @param slic - slic descriptor
+ * @param cmd - command
+ * @param arg - argument
+ * @return 0 - ok
+ */
+int slic_control(struct si3226x_slic *slic, unsigned int cmd, unsigned long arg)
+{
+	int rc;
+	struct si3226x_line *line = slic->lines;
+	int i;
+
+	switch(cmd) {
+	case SI3226X_SET_COMPANDING_MODE:
+		if(	arg != SI_ALAW && arg !=	SI_MLAW)
+			return -EINVAL;
+
+		for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++) {
+			if (line->state == SI_LINE_DISABLE)
+				continue;
+
+			line->companding_mode = arg;
+
+			rc = slic_setup_audio(line);
+			if (rc)
+				return rc;

This interface is not well thought out. If you get an error, the command
has been partially executed, but you have no idea how far.

+		}
+		break;
+
+	case SI3226X_SET_CALLERID_MODE:
+		if(	arg != SI_FSK_BELLCORE && arg != SI_FSK_ETSI
+		    && arg != SI_CALLERID_DTMF)
+			return -EINVAL;
+
+		for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++) {
+			if (line->state == SI_LINE_DISABLE)
+				continue;
+
+			line->callerid_mode = arg;
+		}
+		break;
+	}
+
+	return 0;
+}

+/**
+ * slic line controls over ioctl
+ * @param line - line descriptor
+ * @param cmd - command
+ * @param arg - argument
+ * @return 0 - ok
+ */
+int line_control(struct si3226x_line *line, unsigned int cmd, unsigned long arg)
+{
+	int rc = 0;
+	u8 data;
+	struct si3226x_caller_id caller_id;
+	u8 callerid_buffer[CALLERID_BUF_SIZE];
+
+	switch(cmd) {
+	case SI3226X_SET_CALLERID_MODE:
+		if( arg != SI_FSK_BELLCORE && arg != SI_FSK_ETSI
+		    && arg != SI_CALLERID_DTMF && arg != SI_CALLERID_NONE)
+			return -EINVAL;
+
+		line->callerid_mode = arg;
+		break;
+
+	case SI3226X_SET_ECHO_CANCELATION:
+		if(arg)
+			rc = slic_enable_echo(line);
+		else
+			rc = slic_disable_echo(line);
+		break;
+
+	case SI3226X_SET_LINE_STATE:
+		rc = slic_set_line_state(line, arg);
+		break;
+
+	case SI3226X_CALL:
+		copy_from_user(&caller_id, (__u8 __user *)arg, sizeof caller_id);

must handle errors

+
+		if(caller_id.size > CALLERID_BUF_SIZE)
+			caller_id.size = CALLERID_BUF_SIZE;
+
+		copy_from_user(callerid_buffer, (__u8 __user *)caller_id.data, caller_id.size);

must handle errors

+		rc = slic_line_call(line, callerid_buffer, caller_id.size);
+		break;
+
+	case SI3226X_SEND_DTMF:
+		rc = slic_send_dtmf_digit(line, arg);
+		break;
+
+	case SI3226X_GET_HOOK_STATE:
+		__put_user(line->hook_state, (__u8 __user *)arg);

must handle errors

+		break;
+
+	case SI3226X_GET_DTMF_DIGIT:
+		rc = fifo_pop(&line->dtmf, &data);
+		if (rc)
+			return -ENODATA;
+
+		__put_user(data, (__u8 __user *)arg);

must handle errors

+		break;
+
+	case SI3226X_GET_AUDIO_BLOCK_SIZE:
+		__put_user(line->audio_buffer_size, (__u8 __user *)arg);

must handle errors

+		break;
+
+	case SI3226X_SET_COMPANDING_MODE:
+		if(	arg != SI_ALAW && arg != SI_MLAW)
+			return -EINVAL;
+
+		line->companding_mode = arg;
+
+		rc = slic_setup_audio(line);
+		if (rc)
+			return rc;

a bit pointless

+
+		break;
+
+	case SI3226X_ENABLE_AUDIO:
+		if (line->tdm_dev == NULL)
+			return -ENODEV;
+
+		/* TODO: workaround to fix sound distortion after asterisk restart */
+		if (!line->audio_start_flag) {
+			rc = tdm_run_audio(line->tdm_dev);
+			if (!rc)
+				line->audio_start_flag = 1;
+		}
+
+		break;
+
+	case SI3226X_DISABLE_AUDIO:
+		if (line->tdm_dev == NULL)
+			return -ENODEV;
+
+		rc = tdm_stop_audio(line->tdm_dev);
+		break;
+	}
+
+	return rc;
+}
