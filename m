Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3KDSHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:07:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab3KDSHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:07:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 7/9] KEYS: Add a keyctl function to alter/control a key in
 type-dependent way
To: d.kasatkin@samsung.com, zohar@us.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:23:07 +0000
Message-ID: <20131104162307.10177.70090.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to permit a key to be altered or controlled in a type-dependent
way.  This is given text strings as its command and argument parameters and is
permitted to return a string to a maximum buffer size (including NUL):

	long keyctl_control(key_serial_t keyid,
			    const char *command,
			    char *reply_buffer,
			    size_t reply_size);

The caller must have WRITE permission on a key to be able to perform this
function.  The type is not required to implement this, but if it does, it must
perform its own locking against other 'writes' using the key semaphore.

The command string must begin with the type name and a space so that the method
can check that the command is from its expected set (it is permitted, however,
to honour commands from another type's set).  This should be followed by the
command name and then, optionally, another space and whatever arguments are
required.  The command can be up to 1MB in size including the NUL terminator.

The reply buffer is optional and can be up to 1MB in size.  The actual size of
the reply will be returned and, if necessary, the reply will be truncated to
reply_size.

This can be invoked from the keyctl command in userspace.  One example would be
to use this to change the master key used by an encrypted key:

	keyctl control 1234 "encrypted change-master-key 6789"

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/security/keys.txt |   34 +++++++++++++
 include/linux/key-type.h        |    6 ++
 include/uapi/linux/keyctl.h     |    1 
 security/keys/compat.c          |    6 ++
 security/keys/internal.h        |    2 +
 security/keys/keyctl.c          |  104 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 153 insertions(+)

diff --git a/Documentation/security/keys.txt b/Documentation/security/keys.txt
index 3bbec087fc5f..a5792bcb64b2 100644
--- a/Documentation/security/keys.txt
+++ b/Documentation/security/keys.txt
@@ -1331,6 +1331,40 @@ The structure has a number of fields, some of which are mandatory:
      	 The authorisation key.
 
 
+ (*) long (*control)(struct key *key, char *command, char *reply,
+		     size_t reply_size);
+
+     This method is optional.  If provided, keyctl_control() can be invoked
+     from userspace to perform some type-specific operation upon the key.  If
+     the method is not implemented then error EOPNOTSUPP will be returned.
+
+     The method must provide its own locking against other 'writes' using the
+     key semaphore.
+
+     The command argument will point to a NUL-terminated string up to 1MB in
+     size, including the NUL terminator.  The method may modify the command
+     buffer (eg. with strsep()).
+
+     The command should begin with the type name and a space so that the method
+     can check that the command is from its expected set.  It is permitted,
+     however, to honour commands from another type's set.  This should be
+     followed by the command name and then, optionally, another space and
+     whatever arguments are required.
+
+     The reply buffer will be NULL if userspace didn't ask for a reply.
+     Otherwise it will be a kernel-space buffer the size of which was specified
+     by userspace (max 1MB).  The actual size of the reply should be returned
+     (and can be larger than reply_size).  The caller will copy back the
+     contents of the reply buffer up to reply_size.
+
+     An example might be:
+
+	encrypted change-master-key <key-id>
+
+     The return value is the reply size, 0 (if no reply) or a negative error
+     code.
+
+
 ============================
 REQUEST-KEY CALLBACK SERVICE
 ============================
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 44792ee649de..610669c780f7 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -129,6 +129,12 @@ struct key_type {
 	 */
 	request_key_actor_t request_key;
 
+	/* Control or alter a key (optional)
+	 * - The command string can be modified (eg. with strsep()).
+	 */
+	long (*control)(struct key *key, char *command,
+			char *reply, size_t reply_size);
+
 	/* internal fields */
 	struct list_head	link;		/* link in types list */
 	struct lock_class_key	lock_class;	/* key->sem lock class */
diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index 840cb990abe2..9687b9c726b2 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -57,5 +57,6 @@
 #define KEYCTL_INSTANTIATE_IOV		20	/* instantiate a partially constructed key */
 #define KEYCTL_INVALIDATE		21	/* invalidate a key */
 #define KEYCTL_GET_PERSISTENT		22	/* get a user's persistent keyring */
+#define KEYCTL_CONTROL			23	/* control/alter a key */
 
 #endif /*  _LINUX_KEYCTL_H */
diff --git a/security/keys/compat.c b/security/keys/compat.c
index bbd32c729dbb..78d82d86471f 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -141,6 +141,12 @@ asmlinkage long compat_sys_keyctl(u32 option,
 	case KEYCTL_GET_PERSISTENT:
 		return keyctl_get_persistent(arg2, arg3);
 
+	case KEYCTL_CONTROL:
+		return keyctl_control_key(arg2,
+					  compat_ptr(arg3),
+					  compat_ptr(arg4),
+					  arg5);
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 80b2aac4f50c..4a6944374b0c 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -264,6 +264,8 @@ static inline long keyctl_get_persistent(uid_t uid, key_serial_t destring)
 	return -EOPNOTSUPP;
 }
 #endif
+extern long keyctl_control_key(key_serial_t, const char __user *,
+			       char __user *, size_t);
 
 /*
  * Debugging key validation
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index cee72ce64222..46fe18fe6d16 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1565,6 +1565,104 @@ error_keyring:
 }
 
 /*
+ * Control or alter a key in a type-dependent way.
+ *
+ * The key must grant the caller Write permission and the key type must support
+ * the control op for this to work.
+ *
+ * If successful, the full reply size will be returned.  If the key type does
+ * not support the control op, then -EOPNOTSUPP will be returned.
+ */
+long keyctl_control_key(key_serial_t id,
+			const char __user *_command,
+			char __user *_reply_buffer,
+			size_t reply_size)
+{
+	struct key *key;
+	key_ref_t key_ref;
+	char *command, *reply_buffer = NULL;
+	long cmd_size, ret;
+
+	ret = -EINVAL;
+	if (!_command || reply_size > 1024 * 1024)
+		goto error;
+
+	cmd_size = strnlen_user(_command, 1024 * 1024);
+	if (cmd_size < 0) {
+		ret = cmd_size;
+		goto error;
+	}
+
+	if (cmd_size > 1024 * 1024 - 1)
+		goto error;
+
+	command = vmalloc(cmd_size + 1);
+	if (!command) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	if (copy_from_user(command, _command, cmd_size) != 0) {
+		ret = -EFAULT;
+		goto error_cmd;
+	}
+	if (command[0] == '\0')
+		goto error_cmd;
+
+	if (_reply_buffer) {
+		if (reply_size <= 0)
+			goto error_cmd;
+		if (!access_ok(VERIFY_WRITE, _reply_buffer, reply_size)) {
+			ret = -EFAULT;
+			goto error_cmd;
+		}
+		reply_buffer = vmalloc(reply_size);
+		if (!reply_buffer)
+			goto error_cmd;
+	}
+
+	/* find the target key (which must be writable) */
+	key_ref = lookup_user_key(id, 0, KEY_WRITE);
+	if (IS_ERR(key_ref)) {
+		ret = PTR_ERR(key_ref);
+		goto error_reply;
+	}
+	key = key_ref_to_ptr(key_ref);
+
+	/* call the control function if available */
+	ret = -EOPNOTSUPP;
+	if (!key->type->control)
+		goto error_key;
+
+	ret = key->type->control(key, command, reply_buffer, reply_size);
+	if (ret < 0)
+		goto error_key;
+
+	/* Return the reply.  It's possible that the available reply would have
+	 * exceeded the buffer size, so we return the ideal size but truncate
+	 * if we would otherwise overrun the buffer.
+	 */
+	if (reply_buffer) {
+		if (ret < reply_size)
+			reply_size = ret;
+		if (reply_size > 0 &&
+		    copy_to_user(_reply_buffer, reply_buffer, reply_size) != 0) {
+			ret = -EFAULT;
+			goto error_key;
+		}
+	}
+
+error_key:
+	key_put(key);
+error_reply:
+	vfree(reply_buffer);
+error_cmd:
+	vfree(command);
+error:
+	return ret;
+}
+
+/*
  * The key control system call
  */
 SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
@@ -1670,6 +1768,12 @@ SYSCALL_DEFINE5(keyctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case KEYCTL_GET_PERSISTENT:
 		return keyctl_get_persistent((uid_t)arg2, (key_serial_t)arg3);
 
+	case KEYCTL_CONTROL:
+		return keyctl_control_key((key_serial_t)arg2,
+					  (const char __user *)arg3,
+					  (char __user *)arg4,
+					  (size_t)arg5);
+
 	default:
 		return -EOPNOTSUPP;
 	}

