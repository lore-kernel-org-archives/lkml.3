Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaKDXrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:47:18 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:62530 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbaKDXrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:47:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,316,1413270000"; 
   d="scan'208";a="49744016"
From: "Charley (Hao Chuan) Chu" <charley.chu@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Kernel Oops in __inet_twsk_kill()
Thread-Topic: Kernel Oops in __inet_twsk_kill()
Thread-Index: Ac/4g+N3Z2wE9sbVRYiMvitea8436AABTaFAAAAZ6/A=
Date: Tue, 4 Nov 2014 23:47:18 +0000
Message-ID: <FB8A4655DFD2B34DB16AE06DDDD6C0E231A6F030@SJEXCHMB12.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have situation on our system. It brings the network interface up and down every a few seconds. Eventually, it brings down the system - the kernel crashed due to BUG on in __inet_twsk_kill(). The debug message show following call flow. 


1) time-wait socket is created by tcp_time_wait() when the socket gets into "TIME_WAIT" state. 
    inet_twsk_alloc()               - refcnt= 0
    inet_twsk_hashdance()  - refcnt = 3
    inet_twsk_schedule()      - refcnt = 4
    inet_twsk_put()                 - refcnt = 3
2) tcp_v4_timewait_ack() is called when sync is received 
    inet_twsk_put()                  - refcnt= 2      <== where we thing the problem is
    occasionally, second sync is received, so the inet_twsk_put is called twice - refcnt = 1 
3) twdr_do_twkill_work() is called when timed out
    call __inet_twsk_kill - BUG_ON!!! as refcnt=2 (supposed to be 3).
    call inet_twsk_put()

In a normal case, the callflow only has step 1 and step 3.  Our understanding is the time-wait socket has three references - ehash, bhash and timer death row. In step 2, none of them are touched. Can anyone here explain to us why the inet_twsk_put() is called in tcp_v4_timewait_ack()?

our system has 3.14 kernel.

Any help would be highly appreciated.

Charley Chu

