Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3IQXIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:08:21 -0400
Received: from nm25-vm1.access.bullet.mail.gq1.yahoo.com ([216.39.63.23]:34480
	"EHLO nm25-vm1.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083Ab3IQXIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:08:19 -0400
X-Yahoo-Newman-Id: 212707.3357.bm@smtp117.sbc.mail.gq1.yahoo.com
X-Rocket-Received: from localhost.localdomain (danielfsantos@99.70.244.137 with )
        by smtp117.sbc.mail.gq1.yahoo.com with SMTP; 17 Sep 2013 23:08:19 +0000 UTC
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pIgmChcVM1nUqCJKl0eZg71jTHaDn3IpcSUInq9T5nFmsU6
 L6sifpZ8biq8SLggePWjxku8fj3zzRYanY6HvHP__lRgF4AzJhYu2Yor0ZOx
 fKqsZk7dEBL74jwvW1VBm.EeuUPJrniCUN09qyBcDv7arnsQF.GtuzDPm1QJ
 i_KVkDgKO1IqdOPzwPyaIvgiSGaZNDnxKe_29UPG.pYR_vl9PRnrf7NOd1Pl
 p1BoENgdVpNJBDu6H4vf.EHT_EfY1ohv2PUasPxKxI5kdKOGU84VCypsAhcN
 c67CQiUn.rTalm2mCka3RhKtGis8APZnh9TG1FTrE_I3AUjmtKOaEWJRQbGs
 XcU88xmzbs66zqnct1XEsrWjN4DHj7Qqq1Bp5kqgycAjDYU.Sm6HL7HzYbGB
 Ks8Z1ToeCf.fE1AB5yFIwwl5Vrb_TzWJfyQyjxt5l7BWBEyx5VrqRWTkDK4b
 4MSIicLswrrsuTdB9PZoGzon5Zq3Z2SyUdz7prO3cBkeAVSXMRyZYyEO_M8.
 eKI.qUv3pdU3HM6mQdUb9yOyi52V0qjIlrWKGGg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Subject: [PATCH 0/5] Preliminary: Add error names & descrptions to printks
Date: Tue, 17 Sep 2013 18:08:32 -0500
Message-Id: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a preliminary patch set as the root Makefile changes are not yet
correct.

Summary

Typically, we don't care about error messages or names in the kernel because
userspace will manage that.  But sometimes we need to output an error number
to printks and that creates a situation where a user, system admistrator or
developer must find an error number reference to figure out what went wrong
with a particular driver or whatever.  This patch adds two alternatives at
increasing memory costs:

1. print the number in addition to the name for 2k extra or
2. print the number, name and description for 6k extra.

This is fairly low cost for the person who wants to make life just a little
bit easier. The format of each is respectively the same as the following:

  printk("%d (%s)", err, err_name);
  printk("%d (%s: %s)", err, err_name, err_desc);

Theory

Error messages aren't printed often, so this data and code is designed to be
compact at the expense of speed.  Rather than using an array of strings that
would require both the text and a pointer to that text, we just cram a range
of error names or descriptions into a single string with null character
delimiters.  When we want to retrieve a string, we just iterate through that
string and count nulls.  This is slow, but it keeps it compact. (If this
becomes a bottleneck then something else is seriously wrong! :)

