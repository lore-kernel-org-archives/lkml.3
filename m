Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3LVWrZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 17:47:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40322 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3LVWrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 17:47:24 -0500
Date: Sun, 22 Dec 2013 22:47:15 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: iio_utils.h bug?
Message-ID: <20131222174713.GA3931@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A guy posted this fix on my blog. I couldn't make sense of it.

Thought I'd post it here. I'll send a proper patch file if 
I knew what commit log I needed to write.
And I can't exactly sign-off :s.

I asked him to post but he couldn't/wouldn't.

Regards
ZubairLK


"Defend against buffer overflow of ci_array:

 code always overwrites one entry beyond end of array, now fixed
--Craig Markwardt"

iio_utils.h

@@ -335,6 +335,7 @@ inline int build_channel_array(const char *device_dir,
   while (ent = readdir(dp), ent != NULL) {
     if (strcmp(ent->d_name + strlen(ent->d_name) - strlen("_en"),
          "_en") == 0) {
+      int current_enabled = 0;
       current = &(*ci_array)[count++];
       ret = asprintf(&filename,
                "%s/%s", scan_el_dir, ent->d_name);
       if (ret < 0) {
         ret = -ENOMEM;
         /* decrement count to avoid freeing name */
         count--;
         goto error_cleanup_array;
       }

       sysfsfp = fopen(filename, "r");

       if (sysfsfp == NULL) {
         free(filename);
         ret = -errno;
         goto error_cleanup_array;
       }

-      fscanf(sysfsfp, "%u", &current->enabled);
+      fscanf(sysfsfp, "%u", &current_enabled);
       fclose(sysfsfp);

-      if (!current->enabled) {
+      if (!current_enabled) {
         free(filename);
         count--;
         continue;
       }
+      current->enabled = current_enabled;
       current->scale = 1.0;
       current->offset = 0;
       current->name = strndup(ent->d_name,
