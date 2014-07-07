Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbaGHAfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:35:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaGGXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 49/94] intel_pstate: Correct rounding in busy calculation
Date: Mon,  7 Jul 2014 16:57:39 -0700
Message-Id: <20140707235758.236638761@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Smythies <doug.smythies@gmail.com>

commit 51d211e9c334b9eca3505f4052afa660c3e0606b upstream.

There was a mistake in the actual rounding portion this previous patch:
f0fe3cd7e12d (intel_pstate: Correct rounding in busy calculation) such that
the rounding was asymetric and incorrect.

Severity: Not very serious, but can increase target pstate by one extra value.
For real world work flows the issue should self correct (but I have no proof).
It is the equivalent of different PID gains for positive and negative numbers.

Examples:
 -3.000000 used to round to -4, rounds to -3 with this patch.
 -3.503906 used to round to -5, rounds to -4 with this patch.

Fixes: f0fe3cd7e12d (intel_pstate: Correct rounding in busy calculation)
Signed-off-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -200,10 +200,7 @@ static signed int pid_calc(struct _pid *
 	pid->last_err = fp_error;
 
 	result = pterm + mul_fp(pid->integral, pid->i_gain) + dterm;
-	if (result >= 0)
-		result = result + (1 << (FRAC_BITS-1));
-	else
-		result = result - (1 << (FRAC_BITS-1));
+	result = result + (1 << (FRAC_BITS-1));
 	return (signed int)fp_toint(result);
 }
 


